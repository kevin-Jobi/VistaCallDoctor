// views/profile_filling/profile_filling_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
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

    // Load departments on first build
    viewModel.loadDepartments();

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return ProfileFillingUI(
          formKey: formKey,
          viewModel: viewModel,
          state: state,
        );
      },
    );
  }
}