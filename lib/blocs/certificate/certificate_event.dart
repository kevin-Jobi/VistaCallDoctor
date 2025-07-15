abstract class CertificateEvent {}

class UploadCertificateEvent extends CertificateEvent {
  final String filePath;

  UploadCertificateEvent(this.filePath);
}

class SubmitCertificateEvent extends CertificateEvent {
  final String? description;

  SubmitCertificateEvent({this.description});
}

class CertificateUserIdChanged extends CertificateEvent {
  final String userId;

  CertificateUserIdChanged(this.userId);
}