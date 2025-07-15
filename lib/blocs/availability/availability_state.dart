import 'package:equatable/equatable.dart';

class Availability {
  final List<String> availableDays;
  final String yearsOfExperience;
  final String fees;

  const Availability({
    this.availableDays = const [],
    this.yearsOfExperience = '',
    this.fees = '',
  });
}

class AvailabilityState extends Equatable {
  final Availability availability;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const AvailabilityState({
    required this.availability,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
  });

  AvailabilityState copyWith({
    Availability? availability,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return AvailabilityState(
      availability: availability ?? this.availability,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [availability, isSubmitting, isSuccess, error];
}
