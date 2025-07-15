import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_event.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_state.dart';
import 'package:vista_call_doctor/views/appointment_screen.dart';


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
            MaterialPageRoute(builder: (_) => AppointmentScreen()),
          );
        }
        if (state is DoctorAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Doctor Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
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
                TextButton(
                  onPressed: () {
                    // Navigate to registration screen
                  },
                  child: const Text('Register as Doctor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}