// part of 'doctor_auth_bloc.dart';


import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DoctorAuthState extends Equatable {
  const DoctorAuthState();

  @override
  List<Object> get props => [];
}

class DoctorAuthInitial extends DoctorAuthState {}

class DoctorAuthLoading extends DoctorAuthState {}

class DoctorAuthSuccess extends DoctorAuthState {
  final User user;

  const DoctorAuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class DoctorAuthFailure extends DoctorAuthState {
  final String error;

  const DoctorAuthFailure(this.error);

  @override
  List<Object> get props => [error];
}