import 'package:equatable/equatable.dart';

class Availability {
  final List<String> availableDays;
  final String yearsOfExperience;
  final String fees;
  final Map<String, List<String>> availableTimeSlots;

  const Availability({
    this.availableDays = const [],
    this.yearsOfExperience = '',
    this.fees = '',
    this.availableTimeSlots = const {},
  });

  Availability copyWith({
    List<String>? availableDays,
    String? yearsOfExperience,
    String? fees,
    Map<String, List<String>>? availableTimeSlots,
  }) {
    return Availability(
      availableDays: availableDays ?? this.availableDays,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      fees: fees ?? this.fees,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Availability &&
          runtimeType == other.runtimeType &&
          availableDays == other.availableDays &&
          yearsOfExperience == other.yearsOfExperience &&
          fees == other.fees &&
          availableTimeSlots == other.availableTimeSlots;

  @override
  int get hashCode =>
      availableDays.hashCode ^
      yearsOfExperience.hashCode ^
      fees.hashCode ^
      availableTimeSlots.hashCode;
}




class AvailabilityState extends Equatable {
  final Availability availability;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;
  final bool isLoading;

  const AvailabilityState({
    required this.availability,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
    this.isLoading = false,
  });

  factory AvailabilityState.initial() {
    return AvailabilityState(
      availability: Availability(
        availableDays: [],
        yearsOfExperience: '',
        fees: '',
        availableTimeSlots: {},
      ),
      isLoading: false,
      error: null,
      isSubmitting: false,
    );
  }

  AvailabilityState copyWith({
    Availability? availability,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    bool? isLoading,
  }) {
    return AvailabilityState(
      availability: availability ?? this.availability,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      isLoading: isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [availability, isSubmitting, isSuccess, error, isLoading];
}
