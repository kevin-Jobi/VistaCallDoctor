import 'dart:io';

import 'package:image_picker/image_picker.dart';

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

class ClearCertificate extends CertificateEvent{}

class CaptureImage extends CertificateEvent {
  final ImageSource source;
  CaptureImage({this.source = ImageSource.gallery});
}

class ImageCaptured extends CertificateEvent {
  final File imageFile;
  ImageCaptured(this.imageFile);
}