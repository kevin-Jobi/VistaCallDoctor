import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_state.dart';
import 'package:vista_call_doctor/view_models/doctor_login_view_model.dart';
import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';

class DoctorLoginUI extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final DoctorLoginViewModel viewModel;
  const DoctorLoginUI({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 79, 145, 175),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  _buildTitle(),
                  const SizedBox(height: 30),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(context),
                  const SizedBox(height: 30),
                  _buildLoginButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 
  Widget _buildLogo() {
    return Image.asset(
      'assets/images/loginImage.png',
      height: 220,
    );
  }

    Widget _buildTitle() {
    return Text(
      'Doctor Login',
      style: TextStyle(
        color: Colors.white,
        fontSize: 29,
        fontWeight: FontWeight.bold,
      ),
    );
  }

    Widget _buildEmailField() {
    return CustomTextField(
      controller: emailController,
      labelText: 'Email',
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email';
        }
        return null;
      },
    );
  }

    Widget _buildPasswordField(BuildContext context) {
    return BlocBuilder<DoctorAuthBloc, DoctorAuthState>(
      builder: (context, state) {
        return CustomTextField(
          controller: passwordController,
          obscureText: !state.isPasswordVisible,
          labelText: 'Password',
          prefixIcon: Icons.lock,
          suffixIcon: IconButton(
            icon: Icon(
              state.isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: viewModel.togglePasswordVisibility,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
        );
      },
    );
  }

    Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<DoctorAuthBloc, DoctorAuthState>(
      builder: (context, state) {
        if (state is DoctorAuthLoading) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              viewModel.login(
                emailController.text,
                passwordController.text,
              );
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
