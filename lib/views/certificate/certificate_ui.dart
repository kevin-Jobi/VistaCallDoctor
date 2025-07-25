// views/certificate/certificate_ui.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_state.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_state.dart';
import 'package:vista_call_doctor/view_models/certificate_view_model.dart';

class CertificateUI extends StatelessWidget {
  final CertificateViewModel viewModel;
  final CertificateState state;

  const CertificateUI({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 165, 197),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 165, 197),
        title: const Text(
          'Add Your Certificate',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (state.isSubmitting) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 80),
          _buildCertificateImage(context),
          const Spacer(),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildCertificateImage(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: viewModel.captureImage,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: _buildAvatarChild(),
        ),
      ),
    );
  }

  Widget _buildAvatarChild() {
    if (state.certificatePath != null) {
      return ClipOval(
        child: Image.file(
          File(state.certificatePath!),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }
    return const Icon(Icons.add_a_photo, size: 30, color: Colors.white);
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => viewModel.submitRegistration(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: const Text('Complete Registration'),
    );
  }
}