// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudinary/cloudinary.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
// import 'package:vista_call_doctor/blocs/certificate/certificate_event.dart';
// import 'package:vista_call_doctor/blocs/certificate/certificate_state.dart';

// class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
//   final Cloudinary cloudinary;
//   final FirebaseFirestore firestore;
//   final String doctorId; // Pass current doctor's ID
//   // new
//   final ImagePicker _imagePicker = ImagePicker();

//   CertificateBloc({
//     required this.cloudinary,
//     required this.firestore,
//     required this.doctorId,
//   }) : super(CertificateState.initial()) {

//     on<UploadCertificateEvent>((event, emit) async {
//       emit(state.copyWith(isSubmitting: true));
//       try {
//         final response = await cloudinary.upload(
//           file: event.filePath,
//           resourceType: CloudinaryResourceType.image,
//           folder: 'certificates',
//         );
//         final url = response.secureUrl;
//         emit(
//           state.copyWith(
//             certificatePath: event.filePath,
//             certificateUrl: url,
//             isSubmitting: false,
//             uploadSuccess: true, // Add this to show success message
//           ),
//         );
//       } catch (e) {
//         emit(
//           state.copyWith(
//             isSubmitting: false,
//             errorMessage: 'Upload failed: ${e.toString()}',
//           ),
//         );
//       }
//     });

//     on<CaptureImage>(_onCaptureImage);

//     on<ClearCertificate>((event, emit) {
//       emit(state.copyWith(certificatePath: null));
//     });

//     on<SubmitCertificateEvent>((event, emit) async {
//       if (state.certificateUrl == null) return;

//       emit(state.copyWith(isSubmitting: true));
//       try {
//         await _saveToFirestore(
//           doctorId: doctorId,
//           certificateUrl: state.certificateUrl!,
//           description: event.description,
//         );
//         emit(state.copyWith(isSubmitting: false, submissionSuccess: true));
//       } catch (e) {
//         emit(
//           state.copyWith(
//             isSubmitting: false,
//             errorMessage: 'Submission failed: ${e.toString()}',
//           ),
//         );
//       }
//     });
//   }

//   Future<void> _saveToFirestore({
//     required String doctorId,
//     required String certificateUrl,
//     String? description,
//   }) async {
//     final certId = const Uuid().v4();
//     final certData = {
//       'id': certId,
//       'url': certificateUrl,
//       'status': 'pending',
//       'uploadDate': FieldValue.serverTimestamp(),
//       'description': description ?? '',
//     };

//     await firestore.collection('doctors').doc(doctorId).update({
//       'certifications': FieldValue.arrayUnion([certData]),
//       'verificationStatus': 'pending', // Update overall status
//     });
//   }

//   // new
//   Future<void> _onCaptureImage(
//     CaptureImage event,
//     Emitter<CertificateState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       final pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.gallery, // or camera
//         imageQuality: 85,
//       );
//       if (pickedFile != null) {
//         add(ImageCaptured(File(pickedFile.path)));
//         final response = await cloudinary.upload(
//           file: pickedFile.path,
//           resourceType: CloudinaryResourceType.image,
//           folder: 'certificates',
//         );
//       } else {
//         emit(state.copyWith(isLoading: false));
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(
//           isLoading: false,
//           // error: "Failed to capture image:${e.toString()}",
//         ),
//       );
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_event.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_state.dart';

class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final Cloudinary cloudinary;
  final FirebaseFirestore firestore;
  final String doctorId;
  final ImagePicker _imagePicker = ImagePicker();

  CertificateBloc({
    required this.cloudinary,
    required this.firestore,
    required this.doctorId,
  }) : super(CertificateState.initial()) {
    // Register all event handlers in the constructor
    on<UploadCertificateEvent>(_onUploadCertificate);
    on<CaptureImage>(_onCaptureImage);
    on<ClearCertificate>(_onClearCertificate);
    on<SubmitCertificateEvent>(_onSubmitCertificate);
  }

  Future<void> _onUploadCertificate(
    UploadCertificateEvent event,
    Emitter<CertificateState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      final response = await cloudinary.upload(
        file: event.filePath,
        resourceType: CloudinaryResourceType.image,
        folder: 'certificates',
      );
      emit(state.copyWith(
        certificatePath: event.filePath,
        certificateUrl: response.secureUrl,
        isSubmitting: false,
        uploadSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Upload failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCaptureImage(
    CaptureImage event,
    Emitter<CertificateState> emit,
  ) async { 
    emit(state.copyWith(isLoading: true));
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: event.source,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        // Automatically upload after capturing
        add(UploadCertificateEvent(pickedFile.path));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Image capture failed: ${e.toString()}',
      ));
    }
  }

  void _onClearCertificate(
    ClearCertificate event,
    Emitter<CertificateState> emit,
  ) {
    emit(state.copyWith(
      certificatePath: null,
      certificateUrl: null,
    ));
  }

  Future<void> _onSubmitCertificate(
    SubmitCertificateEvent event,
    Emitter<CertificateState> emit,
  ) async {
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
      'verificationStatus': 'pending',
    });
  }
}