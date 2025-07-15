// part of 'doctor_auth_bloc.dart';

import 'package:equatable/equatable.dart';

abstract class DoctorAuthEvent extends Equatable {
  const DoctorAuthEvent();

  @override
  List<Object> get props => [];
}

class DoctorLoginRequested extends DoctorAuthEvent {
  final String email;
  final String password;

  const DoctorLoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class DoctorLogoutRequested extends DoctorAuthEvent {}