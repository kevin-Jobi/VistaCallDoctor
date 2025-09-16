import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
import 'package:vista_call_doctor/views/certificate/certificate_screen.dart';

import '../blocs/availability/availability_bloc.dart';
import '../blocs/availability/availability_event.dart';

class AvailabilityViewModel {
  final AvailabilityBloc availabilityBloc;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> submitAvailability() async {
    final state = availabilityBloc.state;
    final user = _auth.currentUser;
    if(user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    try{
       await _firestore.collection('doctors').doc(doctorId).update({
      'availability':{
        'availableDays': state.availability.availableDays,
        'yearsOfExperience':state.availability.yearsOfExperience,
        'fees':state.availability.fees,
        'availableTimeSlots':state.availability.availableTimeSlots,
      },
    });
    availabilityBloc.add(const SubmitAvailability());
    } catch (e){
    throw Exception('Failed to save availability: $e');
  }
   
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
