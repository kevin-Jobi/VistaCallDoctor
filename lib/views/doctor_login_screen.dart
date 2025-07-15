import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_event.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_state.dart';
import 'package:vista_call_doctor/views/appointment_screen.dart';
import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';

class DoctorLoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorAuthBloc, DoctorAuthState>(
      listener: (context, state) {
        if (state is DoctorAuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AppointmentScreen()),
          );
        }
        if (state is DoctorAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 79, 145, 175),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/loginImage.png',height: 220,),
                Text(
                  'Doctor Login',

                  style: TextStyle(color: Colors.white,fontSize: 29,fontWeight:FontWeight.bold ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<DoctorAuthBloc, DoctorAuthState>(
                  builder: (context, state) {
                    return CustomTextField(
                      controller: _passwordController,
                      obscureText: !state.isPasswordVisible,
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          context.read<DoctorAuthBloc>().add(
                                const TogglePasswordVisibility(),
                              );
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
                BlocBuilder<DoctorAuthBloc, DoctorAuthState>(
                  builder: (context, state) {
                    if (state is DoctorAuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<DoctorAuthBloc>().add(
                                DoctorLoginRequested(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                      child: const Text('Login'),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}