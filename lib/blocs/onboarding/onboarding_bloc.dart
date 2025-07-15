

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_event.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_state.dart';
import 'package:vista_call_doctor/services/cloudinary_service.dart';


class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final CloudinaryService _cloudinary;

  OnboardingBloc({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required CloudinaryService cloudinary,
  })  : _firestore = firestore,
        _auth = auth,
        _cloudinary = cloudinary,
        super(OnboardingInitial()) {
    on<SubmitOnboarding>(_onSubmitOnboarding);
  }

  Future<void> _onSubmitOnboarding(
    SubmitOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingSubmitting());

    try {
      // 1. First create Firebase Auth account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // 2. Disable account until admin approval
      await _auth.currentUser?.updateProfile(displayName: 'pending_approval');
      await _auth.signOut(); // Immediately log out

      // 3. Upload profile image if exists
      String? profileImageUrl;
      if (event.profileImage != null) {
        profileImageUrl = await _cloudinary.uploadFile(
          filePath: event.profileImage!.path,
          folder: 'doctor-profiles',
        );
      }

      // 4. Upload certificate
      final certificateUrl = await _cloudinary.uploadFile(
        filePath: event.certificatePath,
        folder: 'doctor-certificates',
      );

      // 5. Save all other data to Firestore (without password)
      await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
        'personal': {
          'fullName': event.fullName,
          'age': event.age,
          'dateOfBirth': event.dateOfBirth,
          'email': event.email,
          'gender': event.gender,
          'department': event.department,
          'hospitalName': event.hospitalName,
          'profileImageUrl': profileImageUrl,
        },
        'availability': {
          'availableDays': event.availableDays,
          'yearsOfExperience': event.yearsOfExperience,
          'fees': event.fees,
        },
        'certificateUrl': certificateUrl,
        'verificationStatus': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(OnboardingSuccess());
    } on FirebaseAuthException catch (e) {
      emit(OnboardingFailure(_getAuthErrorMessage(e)));
    } catch (e) {
      emit(OnboardingFailure('Submission failed: ${e.toString()}'));
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}