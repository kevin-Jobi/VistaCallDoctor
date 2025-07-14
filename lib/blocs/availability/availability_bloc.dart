


import 'package:flutter_bloc/flutter_bloc.dart';
import 'availability_event.dart';
import 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc()
    : super(const AvailabilityState(availability: Availability())) {
    on<ToggleDay>((event, emit) {
      final currentDays = List<String>.from(state.availability.availableDays);
      if (currentDays.contains(event.day)) {
        currentDays.remove(event.day);
      } else {
        currentDays.add(event.day);
      }
      print('Toggled day: $event, New days: $currentDays');
      emit(
        state.copyWith(availability: Availability(availableDays: currentDays)),
      );
    });
    on<UpdateYearsOfExperience>((event, emit) {
      print('Updated years: ${event.value}');
      emit(
        state.copyWith(
          availability: Availability(
            yearsOfExperience: event.value,
            availableDays: state.availability.availableDays,
            fees: state.availability.fees,
          ),
        ),
      );
    });
    on<UpdateFees>((event, emit) {
      print('Updated fees: ${event.value}');
      emit(
        state.copyWith(
          availability: Availability(
            fees: event.value,
            availableDays: state.availability.availableDays,
            yearsOfExperience: state.availability.yearsOfExperience,
          ),
        ),
      );
    });
    on<SubmitAvailability>((event, emit) {
      print('Submitting availability');
      emit(state.copyWith(isSubmitting: true));
      // Simulate success
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    });
  }
}