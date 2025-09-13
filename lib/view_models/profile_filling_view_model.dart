import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_event.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/profile/profile_bloc.dart';
import 'package:vista_call_doctor/blocs/profile/profile_event.dart';
import 'package:vista_call_doctor/views/availability/availability_screen.dart';
import 'package:vista_call_doctor/views/availability_screen.dart';

class ProfileFillingViewModel {
  final ProfileBloc profileBloc;
  final AuthBloc authBloc;

  ProfileFillingViewModel(this.profileBloc, this.authBloc);

  void loadDepartments() {
    final authState = authBloc.state;
    if (authState is! GetDepartmentLoadedState) {
      authBloc.add(GetDepartmentEvent());
    }
  }

  void updateFullName(String value) {
    profileBloc.add(UpdateFullName(value));
  }

  void updateAge(String value) {
    profileBloc.add(UpdateAge(value));
  }

  void updateDateOfBirth(String value) {
    profileBloc.add(UpdateDateOfBirth(value));
  }

  void updateEmail(String value) {
    profileBloc.add(UpdateEmail(value));
  }

  void updatePassword(String value) {
    profileBloc.add(UpdatePassword(value));
  }

  void updateConfirmPassword(String value) {
    profileBloc.add(UpdateConfirmPassword(value));
  }

  void updateGender(String value) {
    profileBloc.add(UpdateGender(value));
  }

  void updateDepartment(String value) {
    profileBloc.add(UpdateDepartment(value));
  }

  void updateHospitalName(String value) {
    profileBloc.add(UpdateHospitalName(value));
  }

  void captureImage() {
    profileBloc.add(CaptureImage());
  }

  void togglePasswordVisibility() {
    profileBloc.add(TogglePasswordVisibility());
  }

  void navigateToAvailabilityScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<AvailabilityBloc>(context),
          child: const AvailabilityScreen(),
        ),
      ),
    );
  }
}