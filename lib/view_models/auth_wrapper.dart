import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/views/profile_filling.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../view_models/auth_view_model.dart';
import '../views/welcome_screen.dart';
import '../views/appointment_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final viewModel = AuthViewModel(authBloc);

    viewModel.checkAuthState();

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('AuthWrapper: Current AuthState: $state'); // Debug print
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Authenticated) {
          print(
            'AuthWrapper: Navigating to AppointmentScreen for user: ${state.user}',
          );
          return const AppointmentScreen();
        } else if (state is Unauthenticated) {
          print('AuthWrapper: Navigating to WelcomeScreen');
          return const WelcomeScreen();
        } else if (state is AuthFailure) {
          return Scaffold(body: Center(child: Text('Error: ${state.error}')));
        }
        return const WelcomeScreen();
      },
    );
  }
}
