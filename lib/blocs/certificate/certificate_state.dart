

// import 'package:equatable/equatable.dart';

// class CertificateState extends Equatable {
//   final bool isSubmitting;
//   final String? certificatePath;
//   final String? certificateUrl;

//   const CertificateState({
//     this.isSubmitting = false,
//     this.certificatePath,
//     this.certificateUrl,
//   });

//   CertificateState copyWith({
//     bool? isSubmitting,
//     String? certificatePath,
//     String? certificateUrl,
//   }) {
//     return CertificateState(
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       certificatePath: certificatePath ?? this.certificatePath,
//       certificateUrl: certificateUrl ?? this.certificateUrl,
//     );
//   }

//   static CertificateState initial() => const CertificateState();

//   @override
//   List<Object?> get props => [isSubmitting, certificatePath, certificateUrl];
// }
//*-*-*-*-*-*-*-*-*-*-*-*-*-**-



class CertificateState {
  final bool isSubmitting;
  final String? certificateUrl;
  final String? certificatePath;
  final bool uploadSuccess;
  final bool submissionSuccess;
  final String? errorMessage;
  final String? description;

  CertificateState({
    required this.isSubmitting,
    this.certificateUrl,
    this.certificatePath,
    this.uploadSuccess = false,
    this.submissionSuccess = false,
    this.errorMessage,
    this.description,
  });

  factory CertificateState.initial() => CertificateState(
        isSubmitting: false,
      );

  CertificateState copyWith({
    bool? isSubmitting,
    String? certificateUrl,
    String? certificatePath,
    bool? uploadSuccess,
    bool? submissionSuccess,
    String? errorMessage,
    String? description,
  }) {
    return CertificateState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      certificatePath: certificatePath ?? this.certificatePath,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      description: description ?? this.description,
    );
  }
}