import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_event.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_state.dart';
import 'package:vista_call_doctor/models/doctor_model.dart';
import 'package:vista_call_doctor/views/appointment/appointment_screen.dart';
import 'package:vista_call_doctor/views/appointment_screen.dart';

class DoctorLoginViewModel {
  final DoctorAuthBloc authBloc;

  DoctorLoginViewModel(this.authBloc);

  void togglePasswordVisibility() {
    authBloc.add(TogglePasswordVisibility());
  }

  void login(String email, String password) {
    authBloc.add(DoctorLoginRequested(email.trim(), password.trim()));
  }

  void handleAuthState(BuildContext context, DoctorAuthState state) {
    if (state is DoctorAuthSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppointmentScreen()),
      );
    }
    if(state is DoctorAuthFailure){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
    }
  }
}
