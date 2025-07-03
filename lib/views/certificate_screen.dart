import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/certificate/certificate_bloc.dart';
import '../blocs/certificate/certificate_state.dart';
import '../view_models/certificate_view_model.dart';
import 'appointment_screen.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final certificateBloc = BlocProvider.of<CertificateBloc>(context);
    final viewModel = CertificateViewModel(certificateBloc);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 247, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 247, 255),
        title: const Text(
          'Add Your Certificate',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CertificateBloc, CertificateState>(
          builder: (context, state) {
            if (state.isSubmitting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                const SizedBox(height: 80),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );
                              if (pickedFile != null) {
                                viewModel.uploadCertificate(pickedFile.path);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 60,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedFile != null) {
                                viewModel.uploadCertificate(pickedFile.path);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    size: 60,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (state.certificatePath != null &&
                          state.certificatePath!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Certificate selected: ${state.certificatePath}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (state.certificatePath != null &&
                        state.certificatePath!.isNotEmpty) {
                      viewModel.submitCertificate();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppointmentScreen(),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a certificate image'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
