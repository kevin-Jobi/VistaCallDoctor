import 'package:vista_call_doctor/blocs/certificate/certificate_event.dart';
import '../blocs/certificate/certificate_bloc.dart';

class CertificateViewModel {
  final CertificateBloc certificateBloc;

  CertificateViewModel(this.certificateBloc);

  void uploadCertificate(String filePath) {
    certificateBloc.add(UploadCertificateEvent(filePath));
  }

  void submitCertificate() {
    certificateBloc.add(SubmitCertificateEvent());
  }
}
