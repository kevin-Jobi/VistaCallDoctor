import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_event.dart';
import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
import 'package:vista_call_doctor/views/certificate/certificate_screen.dart';



class AvailabilityViewModel {
  final AvailabilityBloc availabilityBloc;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthBloc authBloc;

  AvailabilityViewModel(this.availabilityBloc, this.authBloc);

  void toggleDay(String day) {
    availabilityBloc.add(ToggleDay(day));
  }

  void updateYearsOfExperience(String years) {
    availabilityBloc.add(UpdateYearsOfExperience(years));
  }

  void updateFees(String fees) {
    availabilityBloc.add(UpdateFees(fees));
  }


  Future<void> updateDaySlots(
    String day,
    List<String> slots, {
    bool saveToFirestore = false,
  }) async {
    // 1️⃣ Immediately update the Bloc state
    availabilityBloc.add(UpdateDaySlots(day, slots));

    // 2️⃣ Save to Firestore (optional, async)
    if (saveToFirestore) {
      try {
        final authState = authBloc.state;
        if (authState is! Authenticated) {
          throw Exception('User not authenticated');
        }
        final user = authState.user;
        final doctorId = user.uid;

        final state = availabilityBloc.state;

        // Save updated availability for that doctor
        await _firestore.collection('doctors').doc(doctorId).set({
          'availability': {
            'availableDays': state.availability.availableDays,
            'availableTimeSlots': state.availability.availableTimeSlots,
            'yearsOfExperience': state.availability.yearsOfExperience,
            'fees': state.availability.fees,
          },
        }, SetOptions(merge: true));
      } catch (e, st) {
        debugPrint('Error saving day slots to Firestore: $e\n$st');
      }
    }
  }

  Future<void> submitAvailability() async {
    final authState = authBloc.state;
    if (authState is! Authenticated) {
      throw Exception('User not authenticated');
    }
    // final user = FirebaseAuth.instance.currentUser;
    final state = availabilityBloc.state;
    final user = authState.user;
    // if(user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    try {
      await _firestore.collection('doctors').doc(doctorId).set({
        'availability': {
          'availableDays': state.availability.availableDays,
          'availableTimeSlots': state.availability.availableTimeSlots,
          'yearsOfExperience': state.availability.yearsOfExperience,
          'fees': state.availability.fees,
        },
      }, SetOptions(merge: true));
      // availabilityBloc.add(const SubmitAvailability());
    } catch (e) {
      throw Exception('Failed to save availability: $e');
    }
  }

  void navigateToCertificateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CertificateScreen()),
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


