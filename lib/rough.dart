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
      backgroundColor: const Color(0xFF2076BD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2076BD),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Complete your professional profile',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: SafeArea(
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
            child: Form(key: formKey, child: _buildContent(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Complete your professional profile',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (state.isSubmitting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2076BD), strokeWidth: 3),
            SizedBox(height: 24),
            Text(
              'Creating your profile...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildProfileImageSection(context),
          const SizedBox(height: 32),
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: 16),
          _buildPersonalInfoSection(),
          const SizedBox(height: 32),
          _buildSectionTitle('Account Security'),
          const SizedBox(height: 16),
          _buildSecuritySection(context),
          const SizedBox(height: 32),
          _buildSectionTitle('Professional Details'),
          const SizedBox(height: 16),
          _buildProfessionalSection(context),
          const SizedBox(height: 40),
          _buildContinueButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2076BD).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: viewModel.captureImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: state.profile.profileImage != null
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFF2076BD), Color(0xFF54B2FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    ),
                    child: _buildAvatarChild(),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2076BD),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to add profile photo',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
    return const Center(
      child: Icon(Icons.person_add, size: 40, color: Colors.white),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          _buildStyledTextField(_buildFullNameField()),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStyledTextField(_buildAgeField())),
              const SizedBox(width: 16),
              Expanded(child: _buildStyledTextField(_buildDateOfBirthField())),
            ],
          ),
          const SizedBox(height: 16),
          _buildStyledDropdown(_buildGenderDropdown()),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          _buildStyledTextField(_buildEmailField()),
          const SizedBox(height: 16),
          _buildStyledTextField(_buildPasswordField(context)),
          const SizedBox(height: 16),
          _buildStyledTextField(_buildConfirmPasswordField(context)),
        ],
      ),
    );
  }

  Widget _buildProfessionalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          _buildStyledDropdown(_buildDepartmentDropdown(context)),
          const SizedBox(height: 16),
          _buildStyledTextField(_buildHospitalNameField()),
        ],
      ),
    );
  }

  Widget _buildStyledTextField(Widget textField) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: textField,
    );
  }

  Widget _buildStyledDropdown(Widget dropdown) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: dropdown,
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
    return DropdownButtonFormField<String>(
      decoration: _modernDropdownDecoration(
        'Select Gender',
        Icons.person_outline,
      ),
      items: ['Male', 'Female', 'Other']
          .map(
            (gender) => DropdownMenuItem(
              value: gender,
              child: Row(
                children: [
                  Icon(
                    gender == 'Male'
                        ? Icons.male
                        : gender == 'Female'
                        ? Icons.female
                        : Icons.transgender,
                    color: const Color(0xFF2076BD),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(gender),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (value) => viewModel.updateGender(value ?? ''),
      value: state.profile.gender.isNotEmpty ? state.profile.gender : null,
      validator: (value) => _validateRequired(value, 'Gender'),
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2076BD)),
      dropdownColor: Colors.white,
    );
  }

  Widget _buildDepartmentDropdown(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is GetDepartmentLoadingState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF2076BD),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Loading departments...',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        } else if (authState is GetDepartmentErrorState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
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
          return DropdownButtonFormField<String>(
            decoration: _modernDropdownDecoration(
              'Select Department',
              Icons.local_hospital_outlined,
            ),
            items: authState.departments
                .map(
                  (department) => DropdownMenuItem(
                    value: department,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.medical_services,
                          color: Color(0xFF2076BD),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(department)),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => viewModel.updateDepartment(value ?? ''),
            value: state.profile.department.isNotEmpty
                ? state.profile.department
                : null,
            validator: (value) => _validateRequired(value, 'Department'),
            borderRadius: BorderRadius.circular(12),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF2076BD),
            ),
            dropdownColor: Colors.white,
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
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2076BD), Color(0xFF54B2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2076BD).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            viewModel.navigateToAvailabilityScreen(context);
          } else {
            _showModernSnackBar(
              context,
              'Please fill all fields correctly',
              Icons.warning_amber_rounded,
              Colors.orange,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  InputDecoration _modernDropdownDecoration(
    String hintText,
    IconData prefixIcon,
  ) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF2076BD), size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2076BD), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
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

  void _showModernSnackBar(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
