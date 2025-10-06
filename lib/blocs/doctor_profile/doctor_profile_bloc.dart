

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'doctor_profile_state.dart';
import 'doctor_profile_event.dart';

class DoctorProfileBloc
    extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final AuthBloc authBloc;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DoctorProfileBloc({required this.authBloc})
      : super(const DoctorProfileState()) {
    on<FetchProfile>(_onFetchProfile);
    on<ProfileNameUpdateRequested>(_onProfileNameUpdateRequested);
    on<ProfileExperienceUpdateRequested>(_onProfileExperienceUpdateRequested);
    on<ProfilePhoneUpdateRequested>(_onProfilePhoneUpdateRequested);
    on<ProfileEmailUpdateRequested>(_onProfileEmailUpdateRequested);
    on<ProfileSpecializationUpdateRequested>(
        _onProfileSpecializationUpdateRequested);
    on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
  }

  Future<void> _onFetchProfile(
      FetchProfile event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        final data = doc.data() ?? {};
        final personal = data['personal'] ?? {};
        final availability = data['availability'] ?? {};
        emit(state.copyWith(
          isLoading: false,
          fullName: personal['fullName'] as String? ?? state.fullName,
          experience: availability['yearsOfExperience'] as String? ?? state.experience,
          phone: personal['phone'] as String? ?? state.phone,
          email: personal['email'] as String? ?? state.email,
          specialization: personal['department'] as String? ?? state.specialization,
          profileImageUrl: personal['profileImageUrl'] as String? ?? state.profileImageUrl,
          availability: availability,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Profile data not found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch profile: $e',
      ));
    }
  }

  Future<void> _onProfileNameUpdateRequested(
      ProfileNameUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.fullName': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        fullName: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update name: $e',
      ));
    }
  }

  Future<void> _onProfileExperienceUpdateRequested(
      ProfileExperienceUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'availability.yearsOfExperience': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        experience: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update experience: $e',
      ));
    }
  }

  Future<void> _onProfilePhoneUpdateRequested(
      ProfilePhoneUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.phone': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        phone: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update phone: $e',
      ));
    }
  }

  Future<void> _onProfileEmailUpdateRequested(
      ProfileEmailUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.email': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        email: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update email: $e',
      ));
    }
  }

  Future<void> _onProfileSpecializationUpdateRequested(
      ProfileSpecializationUpdateRequested event,
      Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.department': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        specialization: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update specialization: $e',
      ));
    }
  }

  Future<void> _onProfileImageUpdateRequested(
      ProfileImageUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    // Placeholder for image update logic
    emit(state.copyWith(isLoading: false));
  }
}