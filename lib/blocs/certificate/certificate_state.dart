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