import 'package:flutter_bloc/flutter_bloc.dart';
import 'availability_event.dart';
import 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc()
    : super(const AvailabilityState(availability: Availability())) {
    on<ToggleDay>((event, emit) {
      final currentDays = List<String>.from(state.availability.availableDays);
      final currentSlots = Map<String, List<String>>.from(
        state.availability.availableTimeSlots,
      );
      if (currentDays.contains(event.day)) {
        currentDays.remove(event.day);
        currentSlots.remove(event.day);
      } else {
        currentDays.add(event.day);
      }
      print('Toggled day: $event, New days: $currentDays');
      emit(
        state.copyWith(
          availability: state.availability.copyWith(
            availableDays: currentDays,
            availableTimeSlots: currentSlots,
          ),
        ),
      );
    });
    on<UpdateYearsOfExperience>((event, emit) {
      print('Updated years: ${event.value}');
      emit(
        state.copyWith(
          availability: state.availability.copyWith(
            yearsOfExperience: event.value,
            availableDays: state.availability.availableDays,
            fees: state.availability.fees,
            availableTimeSlots: state.availability.availableTimeSlots,
          ),
        ),
      );
    });
    on<UpdateFees>((event, emit) {
      print('Updated fees: ${event.value}');
      emit(
        state.copyWith(
          availability: state.availability.copyWith(
            fees: event.value,
            availableDays: state.availability.availableDays,
            yearsOfExperience: state.availability.yearsOfExperience,
            availableTimeSlots: state.availability.availableTimeSlots,
          ),
        ),
      );
    });

    on<UpdateDaySlots>((event, emit) {
      print('Update slots for${event.day}: ${event.slots}');
      final currentSlots = Map<String, List<String>>.from(
        state.availability.availableTimeSlots,
      );
      currentSlots[event.day] = event.slots;
      emit(
        state.copyWith(
          availability: state.availability.copyWith(
            availableDays: state.availability.availableDays,
            yearsOfExperience: state.availability.yearsOfExperience,
            fees: state.availability.fees,
            availableTimeSlots: currentSlots,
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
    on<ResetAvailability>((event, emit) {
      print('Reseting availability');
      emit(const AvailabilityState(availability: Availability()));
    });
  }
}
