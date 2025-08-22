import 'package:flutter/material.dart';
import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
import 'package:vista_call_doctor/views/certificate/certificate_screen.dart';
import 'package:vista_call_doctor/views/certificate_screen.dart';

import '../blocs/availability/availability_bloc.dart';
import '../blocs/availability/availability_event.dart';

class AvailabilityViewModel {
  final AvailabilityBloc availabilityBloc;

  AvailabilityViewModel(this.availabilityBloc);

  void toggleDay(String day) {
    availabilityBloc.add(ToggleDay(day));
  }

  void updateYearsOfExperience(String years) {
    availabilityBloc.add(UpdateYearsOfExperience(years));
  }

  void updateFees(String fees) {
    availabilityBloc.add(UpdateFees(fees));
  }

  void updateDaySlots(String day, List<String> slots){
      availabilityBloc.add( UpdateDaySlots(day,slots));
  }

  void submitAvailability() {
    availabilityBloc.add(const SubmitAvailability());
  }

    void navigateToCertificateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CertificateScreen(),
      ),
    );
  }

    String? validateYearsOfExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your years of experience';
    }
    final years = int.tryParse(value);
    if (years == null || years < 0) {
      return 'Please enter a valid number of years';
    }
    return null;
  }

    String? validateFees(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your fees';
    }
    final fees = int.tryParse(value);
    if (fees == null || fees <= 0) {
      return 'Please enter a valid positive fee amount';
    }
    return null;
  }

    bool validateForm(AvailabilityState state) {
    return state.availability.availableDays.isNotEmpty &&
        state.availability.yearsOfExperience.isNotEmpty &&
        state.availability.fees.isNotEmpty;
  }

}
