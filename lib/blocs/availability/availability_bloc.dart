
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_event.dart';
import 'package:vista_call_doctor/blocs/availability/availability_state.dart';


class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc() : super(AvailabilityState.initial()) {
    on<ToggleDay>(_onToggleDay);
    on<UpdateDaySlots>(_onUpdateDaySlots);
    on<UpdateYearsOfExperience>(_onUpdateYearsOfExperience);
    on<UpdateFees>(_onUpdateFees);
    on<LoadAvailability>(_onLoadAvailability);
    on<SubmitAvailability>(_onSubmitAvailability);
  }

void _onToggleDay(ToggleDay event, Emitter<AvailabilityState> emit) {
    print('Handling ToggleDay for ${event.day}');
    final currentDays = List<String>.from(state.availability.availableDays);
    if (currentDays.contains(event.day)) {
      currentDays.remove(event.day);
    } else {
      currentDays.add(event.day);
    }
    emit(state.copyWith(availability: state.availability.copyWith(availableDays: currentDays)));
    print('Updated availableDays: $currentDays');
  }



void _onUpdateDaySlots(UpdateDaySlots event, Emitter<AvailabilityState> emit) {
  final currentSlots = Map<String, List<String>>.from(state.availability.availableTimeSlots);
  currentSlots[event.day] = event.slots;
  final updatedDays = List<String>.from(state.availability.availableDays);
  if (event.slots.isNotEmpty && !updatedDays.contains(event.day)) {
    updatedDays.add(event.day);
  }
  emit(state.copyWith(
    availability: state.availability.copyWith(
      availableTimeSlots: currentSlots,
      availableDays: updatedDays,
    ),
  ));
}

  void _onUpdateYearsOfExperience(UpdateYearsOfExperience event, Emitter<AvailabilityState> emit) {
    emit(state.copyWith(availability: state.availability.copyWith(yearsOfExperience: event.years)));
  }

  void _onUpdateFees(UpdateFees event, Emitter<AvailabilityState> emit) {
    emit(state.copyWith(availability: state.availability.copyWith(fees: event.fees)));
  }

  void _onLoadAvailability(LoadAvailability event, Emitter<AvailabilityState> emit) {
    // Simulate loading from Firestore or other source
    emit(state.copyWith(isLoading: true));
    // Replace with actual data loading logic
    final loadedAvailability = Availability(
      availableDays: ['Mon', 'Tue'], // Example data
      yearsOfExperience: '5',
      fees: '1000',
      availableTimeSlots: {'Mon': ['09:00-10:00'], 'Tue': ['10:00-11:00']},
    );
    emit(state.copyWith(availability: loadedAvailability, isLoading: false));
  }

  void _onSubmitAvailability(SubmitAvailability event, Emitter<AvailabilityState> emit) {
    emit(state.copyWith(isSubmitting: true));
    // Simulate submission (e.g., to Firestore)
    emit(state.copyWith(isSubmitting: false));
  }
}



