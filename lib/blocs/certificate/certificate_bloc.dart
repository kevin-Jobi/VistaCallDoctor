import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_event.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_state.dart';

class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final Cloudinary cloudinary;
  final FirebaseFirestore firestore;
  final String doctorId; // Pass current doctor's ID

  CertificateBloc({
    required this.cloudinary,
    required this.firestore,
    required this.doctorId,
  }) : super(CertificateState.initial()) {
    
    on<UploadCertificateEvent>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      try {
        final response = await cloudinary.upload(
          file: event.filePath,
          resourceType: CloudinaryResourceType.image,
          folder: 'certificates',
        );
        final url = response.secureUrl;
        emit(state.copyWith(
          certificatePath: event.filePath,
          certificateUrl: url,
          isSubmitting: false,
          uploadSuccess: true, // Add this to show success message
        ));
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Upload failed: ${e.toString()}',
        ));
      }
    });

    on<SubmitCertificateEvent>((event, emit) async {
      if (state.certificateUrl == null) return;
      
      emit(state.copyWith(isSubmitting: true));
      try {
        await _saveToFirestore(
          doctorId: doctorId,
          certificateUrl: state.certificateUrl!,
          description: event.description,
        );
        emit(state.copyWith(
          isSubmitting: false,
          submissionSuccess: true,
        ));
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Submission failed: ${e.toString()}',
        ));
      }
    });
  }

  Future<void> _saveToFirestore({
    required String doctorId,
    required String certificateUrl,
    String? description,
  }) async {
    final certId = const Uuid().v4();
    final certData = {
      'id': certId,
      'url': certificateUrl,
      'status': 'pending',
      'uploadDate': FieldValue.serverTimestamp(),
      'description': description ?? '',
    };

    await firestore.collection('doctors').doc(doctorId).update({
      'certifications': FieldValue.arrayUnion([certData]),
      'verificationStatus': 'pending', // Update overall status
    });
  }
}
