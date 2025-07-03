

import 'package:equatable/equatable.dart';

class CertificateState extends Equatable {
  final bool isSubmitting;
  final String? certificatePath;
  final String? certificateUrl;

  const CertificateState({
    this.isSubmitting = false,
    this.certificatePath,
    this.certificateUrl,
  });

  CertificateState copyWith({
    bool? isSubmitting,
    String? certificatePath,
    String? certificateUrl,
  }) {
    return CertificateState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      certificatePath: certificatePath ?? this.certificatePath,
      certificateUrl: certificateUrl ?? this.certificateUrl,
    );
  }

  static CertificateState initial() => const CertificateState();

  @override
  List<Object?> get props => [isSubmitting, certificatePath, certificateUrl];
}
