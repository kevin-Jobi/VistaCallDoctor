import 'package:flutter/material.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/view_models/auth_view_model.dart';
import 'package:vista_call_doctor/views/doctor_login/doctor_login_screen.dart';
import 'package:vista_call_doctor/views/profile_filling/profile_filling_screen.dart';

class WelcomeScreenUi extends StatelessWidget {
  final AuthState state;
  final AuthViewModel viewModel;
  const WelcomeScreenUi({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContext(context),
        ),
      ),
    );
  }

  Widget _buildContext(BuildContext context) {
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AuthFailure) {
      return _buildErrorState(context);
    }
    return _buildWelcomeContent(context);
  }

  Widget _buildErrorState(BuildContext context) {
    final error = (state as AuthFailure).error;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => viewModel.signInWithGoogle(),
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Sign in with Google'),
            style: _buttonStyle(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildLogo(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 15),
          _buildDescription(),
          const SizedBox(height: 25),
          _buildLoginButton(context),
          const SizedBox(height: 15),
          _buildSignUpButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/Rectangle 69.png',
      height: 220,
      width: double.infinity,
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Welcome to \n VistaDoctor',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 29,
        color: Color.fromARGB(255, 7, 47, 146),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Join our trusted network.\nRegister your profile, manage appointments,\nand connect with patients.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton.icon(
      // onPressed: () => viewModel.navigateToLogin(context),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorLoginScreen()),
        );
      },
      icon: const Icon(Icons.login),
      label: const Text('Login to Account', style: TextStyle(fontSize: 18)),
      style: _buttonStyle(),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      // onPressed: () => viewModel.navigateToSignUp(context),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileFillingScreen()),
        );
      },
      style: _buttonStyle(),
      child: const Text('Create Account', style: TextStyle(fontSize: 18)),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 16, 22, 121),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }
}
