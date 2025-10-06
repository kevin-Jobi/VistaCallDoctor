


import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_event.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_state.dart';
import 'package:vista_call_doctor/models/profile_model.dart';
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
      // Use existing authenticated user
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Upload profile image if exists
      String? profileImageUrl;
      if (event.profileImage != null) {
        profileImageUrl = await _cloudinary.uploadFile(
          filePath: event.profileImage!.path,
          folder: 'doctor-profiles',
        );
      }

      // Upload certificate
      final certificateUrl = await _cloudinary.uploadFile(
        filePath: event.certificatePath,
        folder: 'doctor-certificates',
      );

      // Create ProfileModel instance
      final profile = ProfileModel(
        fullName: event.fullName,
        age: event.age,
        dateOfBirth: event.dateOfBirth,
        email: event.email,
        password: event.password, // Optional, not stored here
        confirmPassword: event.password, // For validation, not stored
        gender: event.gender,
        department: event.department,
        hospitalName: event.hospitalName,
        profileImage: event.profileImage,
        profileImageUrl: profileImageUrl,
        availableDays: event.availableDays,
        yearsOfExperience: event.yearsOfExperience,
        fees: event.fees,
        certificatePath: event.certificatePath,
        certificateUrl: certificateUrl,
        verificationStatus: 'pending',
      );

      // Save to Firestore using ProfileModel
      final doctorId = user.uid;
      print('Saving data for doctorId: $doctorId with fullName: ${event.fullName}');
      await _firestore.collection('doctors').doc(doctorId).set(profile.toFirestore(), SetOptions(merge: true));

      // Sign out immediately
      await _auth.signOut();

      emit(OnboardingSuccess());
    } catch (e) {
      print('Onboarding error: $e'); // Debug log
      emit(OnboardingFailure('Submission failed: ${e.toString()}'));
    }
  }
}