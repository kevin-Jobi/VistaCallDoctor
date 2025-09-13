



import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_event.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_state.dart';
import 'package:vista_call_doctor/models/profile_model.dart'; // Import ProfileModel
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
      // Create Firebase Auth account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

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
        password: event.password, // Will be hashed later if needed, not stored here
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
      final doctorId = userCredential.user!.uid;
      print('Saving data for doctorId: $doctorId with fullName: ${event.fullName}');
      await _firestore.collection('doctors').doc(doctorId).set(profile.toFirestore());

      // Sign out immediately
      await _auth.signOut();

      emit(OnboardingSuccess());
    } on FirebaseAuthException catch (e) {
      emit(OnboardingFailure(_getAuthErrorMessage(e)));
    } catch (e) {
      print('Onboarding error: $e'); // Debug log
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