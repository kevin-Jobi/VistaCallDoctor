import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class GetDepartmentLoadingState extends AuthState {}

class GetDepartmentLoadedState extends AuthState {
  final List<String> departments;

  const GetDepartmentLoadedState(this.departments);

  @override
  List<Object?> get props => [departments];
}

class GetDepartmentErrorState extends AuthState {
  final String error;

  const GetDepartmentErrorState(this.error);

  @override
  List<Object?> get props => [error];
}