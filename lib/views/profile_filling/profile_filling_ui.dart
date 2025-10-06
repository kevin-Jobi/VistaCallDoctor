import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/blocs/profile/profile_bloc.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Add Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 32, 118, 189),
            Color.fromARGB(255, 45, 130, 200),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header section with profile image
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildModernProfileImage(context),
                  const SizedBox(height: 16),
                  const Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your information to get started',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Form section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: Form(key: formKey, child: _buildFormContent(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    if (state.isSubmitting) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 32, 118, 189),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Creating your profile...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: 20),
          _buildFullNameField(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildAgeField()),
              const SizedBox(width: 16),
              Expanded(child: _buildGenderDropdown()),
            ],
          ),
          const SizedBox(height: 16),
          _buildDateOfBirthField(),
          const SizedBox(height: 32),

          _buildSectionTitle('Account Details'),
          const SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(context),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(context),
          const SizedBox(height: 32),

          _buildSectionTitle('Professional Information'),
          const SizedBox(height: 20),
          _buildDepartmentDropdown(context),
          const SizedBox(height: 16),
          _buildHospitalNameField(),
          const SizedBox(height: 40),

          _buildModernContinueButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildModernProfileImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: GestureDetector(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: _buildAvatarChild(),
            ),
            onTap: viewModel.captureImage,
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              size: 18,
              color: Color.fromARGB(255, 32, 118, 189),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarChild() {
    if (state.profile.profileImage != null) {
      return ClipOval(
        child: Image.file(
          state.profile.profileImage!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.3),
      ),
      child: const Icon(Icons.person_rounded, size: 40, color: Colors.white),
    );
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true, // 👈 Important
        decoration: _modernDropdownDecoration('Select Gender'),
        items: ['Male', 'Female', 'Other']
            .map(
              (gender) => DropdownMenuItem(
                value: gender,
                child: Text(
                  gender,
                  overflow: TextOverflow.ellipsis, // 👈 Prevents overflow
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) => viewModel.updateGender(value ?? ''),
        value: state.profile.gender.isNotEmpty ? state.profile.gender : null,
        validator: (value) => _validateRequired(value, 'Gender'),
        borderRadius: BorderRadius.circular(16),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color.fromARGB(255, 32, 118, 189),
        ),
      ),
    );
  }

  Widget _buildDepartmentDropdown(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is GetDepartmentLoadingState) {
          return Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 32, 118, 189),
                  ),
                ),
              ),
            ),
          );
        } else if (authState is GetDepartmentErrorState) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error: ${authState.error}',
                    style: TextStyle(color: Colors.red.shade600),
                  ),
                ),
              ],
            ),
          );
        } else if (authState is GetDepartmentLoadedState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: _modernDropdownDecoration('Select Department'),
              items: authState.departments
                  .map(
                    (department) => DropdownMenuItem(
                      value: department,
                      child: Text(
                        department,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => viewModel.updateDepartment(value ?? ''),
              value: state.profile.department.isNotEmpty
                  ? state.profile.department
                  : null,
              validator: (value) => _validateRequired(value, 'Department'),
              borderRadius: BorderRadius.circular(16),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color.fromARGB(255, 32, 118, 189),
              ),
            ),
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


Widget _buildModernContinueButton(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 56,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF4F91AF), Color(0xFF54B2FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: ElevatedButton(
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          final state = context.read<ProfileBloc>().state;
          viewModel.registerUser(state.profile.email, state.profile.password, context)
            .then((_) {
              // Navigation is handled by BlocListener in ProfileFillingScreen
            });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text(
        'Continue',
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

  InputDecoration _modernDropdownDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 32, 118, 189),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }
}
