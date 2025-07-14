// // import 'package:equatable/equatable.dart';

// part of 'onboarding_bloc.dart';

// abstract class OnboardingState extends Equatable {
//   const OnboardingState();

//   @override
//   List<Object> get props => [];
// }

// class OnboardingInitial extends OnboardingState {}

// class OnboardingSubmitting extends OnboardingState {}

// class OnboardingSuccess extends OnboardingState {}

// class OnboardingFailure extends OnboardingState {
//   final String error;

//   const OnboardingFailure(this.error);

//   @override
//   List<Object> get props => [error];
// }


import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingSubmitting extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {}

class OnboardingFailure extends OnboardingState {
  final String error;
  final String? email; // For resending verification

  const OnboardingFailure(this.error, {this.email});

  @override
  List<Object> get props => [error];
}