



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/blocs/profile/profile_bloc.dart';
import 'package:vista_call_doctor/blocs/profile/profile_state.dart';
import 'package:vista_call_doctor/view_models/profile_filling_view_model.dart';
import 'profile_filling_ui.dart';


class ProfileFillingScreen extends StatelessWidget {
  const ProfileFillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final viewModel = ProfileFillingViewModel(profileBloc, authBloc);
    final formKey = GlobalKey<FormState>();

    viewModel.loadDepartments();

    bool navigated = false; // 👈 Prevent multiple pushes

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated && !navigated) {
          navigated = true; // ✅ Mark as done
          print('Navigating once to AvailabilityScreen');
          viewModel.navigateToAvailabilityScreen(context);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: ${state.error}')),
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return ProfileFillingUI(
            formKey: formKey,
            viewModel: viewModel,
            state: state,
          );
        },
      ),
    );
  }
}
