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
  final String value;
  const UpdateYearsOfExperience(this.value);

  @override
  List<Object> get props => [value];
}

class UpdateFees extends AvailabilityEvent {
  final String value;
  const UpdateFees(this.value);

  @override
  List<Object> get props => [value];
}

class SubmitAvailability extends AvailabilityEvent {
  const SubmitAvailability();

  @override
  List<Object> get props => [];
}
