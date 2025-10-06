import 'dart:core';

import 'package:equatable/equatable.dart';

abstract class AvailabilityEvent extends Equatable {
  const AvailabilityEvent();

  @override
  List<Object> get props => [];
}

class ToggleDay extends AvailabilityEvent {
  final String day;
  const ToggleDay(this.day);

  @override
  List<Object> get props => [day];
}

class UpdateYearsOfExperience extends AvailabilityEvent {
  final String years;
  const UpdateYearsOfExperience(this.years);

  @override
  List<Object> get props => [years];
}

class UpdateFees extends AvailabilityEvent {
  final String fees;
  const UpdateFees(this.fees);

  @override
  List<Object> get props => [fees];
}

class UpdateDaySlots extends AvailabilityEvent {
  final String day;
  final List<String> slots;
  const UpdateDaySlots(this.day, this.slots);

  @override
  List<Object> get props => [day, slots];
}

class SubmitAvailability extends AvailabilityEvent {
  const SubmitAvailability();

  @override
  List<Object> get props => [];
}

class ResetAvailability extends AvailabilityEvent {
  const ResetAvailability();

  @override
  List<Object> get props => [];
}

class LoadAvailability extends AvailabilityEvent {
  const LoadAvailability();

  @override
  List<Object> get props => [];
}



