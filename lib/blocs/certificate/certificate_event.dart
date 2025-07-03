abstract class CertificateEvent {}

class UploadCertificateEvent extends CertificateEvent {
  final String filePath;
  UploadCertificateEvent(this.filePath);
}

class SubmitCertificateEvent extends CertificateEvent {}






































// import 'package:equatable/equatable.dart';

// abstract class CertificateEvent extends Equatable {
//   const CertificateEvent();

//   @override
//   List<Object> get props => [];
// }

// class UploadCertificate extends CertificateEvent {
//   final String path;
//   const UploadCertificate(this.path);

//   @override
//   List<Object> get props => [path];
// }

// class SubmitCertificate extends CertificateEvent {
//   const SubmitCertificate();

//   @override
//   List<Object> get props => [];
// }