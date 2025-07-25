// views/profile_filling/profile_filling_ui.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/blocs/profile/profile_state.dart';
import 'package:vista_call_doctor/view_models/profile_filling_view_model.dart';
import 'package:vista_call_doctor/views/widgets/custom_date_picker.dart';
import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';

class ProfileFillingUI extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ProfileFillingViewModel viewModel;
  final ProfileState state;

  const ProfileFillingUI({
    super.key,
    required this.formKey,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 118, 189),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 118, 189),
        title: const Text('Add Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (state.isSubmitting) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileImage(context),
          const SizedBox(height: 20),
          _buildFullNameField(),
          _buildAgeField(),
          _buildDateOfBirthField(),
          _buildEmailField(),
          _buildPasswordField(context),
          _buildConfirmPasswordField(context),
          const SizedBox(height: 10),
          _buildGenderDropdown(),
          const SizedBox(height: 15),
          _buildDepartmentDropdown(context),
          const SizedBox(height: 10),
          _buildHospitalNameField(),
          const SizedBox(height: 20),
          _buildContinueButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: _buildAvatarChild(),
      ),
      onTap: viewModel.captureImage,
    );
  }

  Widget _buildAvatarChild() {
    if (state.profile.profileImage != null) {
      return ClipOval(
        child: Image.file(
          state.profile.profileImage!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }
    return const Icon(Icons.add_a_photo, size: 30, color: Colors.white);
  }

  Widget _buildFullNameField() {
    return CustomTextField(
      labelText: 'Full Name',
      keyboardType: TextInputType.text,
      validator: (value) => _validateRequired(value, 'Full name'),
      onChanged: viewModel.updateFullName,
    );
  }

  Widget _buildAgeField() {
    return CustomTextField(
      labelText: 'Age',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your age';
        final age = int.tryParse(value);
        if (age == null || age < 18 || age > 100) {
          return 'Age must be between 18 and 100';
        }
        return null;
      },
      onChanged: viewModel.updateAge,
    );
  }

  Widget _buildDateOfBirthField() {
    return CustomDatePickerField(
      labelText: 'Date of Birth',
      value: state.profile.dateOfBirth,
      validator: (value) => _validateRequired(value, 'Date of birth'),
      onChanged: viewModel.updateDateOfBirth,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onChanged: viewModel.updateEmail,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      labelText: 'Password',
      isPasswordField: true,
      isPasswordVisible: state.isPasswordVisible,
      onToggleVisibility: viewModel.togglePasswordVisibility,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your password';
        if (value.length < 8) return 'Password must be at least 8 characters';
        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Must contain at least one uppercase letter';
        }
        if (!RegExp(r'[a-z]').hasMatch(value)) {
          return 'Must contain at least one lowercase letter';
        }
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Must contain at least one number';
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
          return 'Must contain at least one special character';
        }
        return null;
      },
      onChanged: viewModel.updatePassword,
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return CustomTextField(
      labelText: 'Confirm Password',
      isPasswordField: true,
      isPasswordVisible: state.isPasswordVisible,
      onToggleVisibility: viewModel.togglePasswordVisibility,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please confirm password';
        if (value != state.profile.password) return 'Passwords do not match';
        return null;
      },
      onChanged: viewModel.updateConfirmPassword,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: _dropdownDecoration('Select Gender'),
      items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(
        value: gender,
        child: Text(gender),
      )).toList(),
      onChanged: (value) => viewModel.updateGender(value ?? ''),
      value: state.profile.gender.isNotEmpty ? state.profile.gender : null,
      validator: (value) => _validateRequired(value, 'Gender'),
      borderRadius: BorderRadius.circular(30),
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  Widget _buildDepartmentDropdown(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is GetDepartmentLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (authState is GetDepartmentErrorState) {
          return Text('Error: ${authState.error}');
        } else if (authState is GetDepartmentLoadedState) {
          return DropdownButtonFormField<String>(
            decoration: _dropdownDecoration('Select Department'),
            items: authState.departments.map((department) => DropdownMenuItem(
              value: department,
              child: Text(department),
            )).toList(),
            onChanged: (value) => viewModel.updateDepartment(value ?? ''),
            value: state.profile.department.isNotEmpty 
                ? state.profile.department 
                : null,
            validator: (value) => _validateRequired(value, 'Department'),
            borderRadius: BorderRadius.circular(30),
            icon: const Icon(Icons.arrow_drop_down),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHospitalNameField() {
    return CustomTextField(
      labelText: 'Hospital Name',
      keyboardType: TextInputType.text,
      validator: (value) => _validateRequired(value, 'Hospital name'),
      onChanged: viewModel.updateHospitalName,
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          viewModel.navigateToAvailabilityScreen(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: const Text('Continue'),
    );
  }

  InputDecoration _dropdownDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 229, 229, 229),
    );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }
}