

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as context;
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/profile/profile_bloc.dart';
import 'certificate_event.dart';
import 'certificate_state.dart';

class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final Cloudinary cloudinary;
  final FirebaseFirestore firestore;

  CertificateBloc(this.cloudinary, this.firestore)
    : super(CertificateState.initial()) {
    on<UploadCertificateEvent>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      try {
        final response = await cloudinary.upload(
          file: event.filePath,
          resourceType: CloudinaryResourceType.image,
          folder: 'certificates',
        );
        final url = response.secureUrl;
        emit(state.copyWith(certificateUrl: url, isSubmitting: false));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false));
        // Handle error (e.g., show snackbar in UI)
      }
    });

    on<SubmitCertificateEvent>((event, emit) async {
      if (state.certificateUrl != null) {
        emit(state.copyWith(isSubmitting: true));
        try {
          // Store data in Firestore (see Step 2)
          await _saveToFirestore(state.certificateUrl!);
          emit(state.copyWith(isSubmitting: false));
        } catch (e) {
          emit(state.copyWith(isSubmitting: false));
          // Handle error
        }
      }
    });
  }

  Future<void> _saveToFirestore(String certificateUrl) async {
    // Placeholder for Firestore save logic (see Step 2)
  }

  //   Future<void> _saveToFirestore(String certificateUrl) async {
  //   final profileBloc = context.read<ProfileBloc>();
  //   final availabilityBloc = context.read<AvailabilityBloc>();
  //   final profileState = profileBloc.state;
  //   final availabilityState = availabilityBloc.state;

  //   await firestore.collection('doctors').add({
  //     'fullName': profileState.profile.fullName,
  //     'age': profileState.profile.age,
  //     'gender': profileState.profile.gender,
  //     'department': profileState.profile.department,
  //     'hospitalName': profileState.profile.hospitalName,
  //     'availableDays': availabilityState.availability.availableDays,
  //     'yearsOfExperience': availabilityState.availability.yearsOfExperience,
  //     'fees': availabilityState.availability.fees,
  //     'certificateUrl': certificateUrl,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });
  // }
}
