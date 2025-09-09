import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_event.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_event.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_bloc.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_event.dart';
import 'package:vista_call_doctor/blocs/profile/profile_bloc.dart';
import 'package:vista_call_doctor/services/dialog_service.dart';
import 'package:vista_call_doctor/views/welcome/welcome_screen.dart';
import '../blocs/certificate/certificate_bloc.dart';

class CertificateViewModel {
  final CertificateBloc certificateBloc;
  final OnboardingBloc onboardingBloc;
  final ProfileBloc profileBloc;
  final AvailabilityBloc availabilityBloc;

  CertificateViewModel(
    this.certificateBloc,
    this.onboardingBloc,
    this.profileBloc,
    this.availabilityBloc,
  );

  void captureImage() {
    certificateBloc.add(CaptureImage());
  }

  Future<void> submitRegistration(BuildContext context) async {
    final state = certificateBloc.state;
    if (state.certificatePath == null) return;

    final profileState = profileBloc.state;
    final availabilityState = availabilityBloc.state;

    onboardingBloc.add(
      SubmitOnboarding(
        fullName: profileState.profile.fullName,
        age: profileState.profile.age,
        dateOfBirth: profileState.profile.dateOfBirth,
        email: profileState.profile.email,
        password: profileState.profile.password,
        gender: profileState.profile.gender,
        department: profileState.profile.department,
        hospitalName: profileState.profile.hospitalName,
        profileImage: profileState.profile.profileImage,
        availableDays: availabilityState.availability.availableDays,
        yearsOfExperience: availabilityState.availability.yearsOfExperience,
        fees: availabilityState.availability.fees,
        certificatePath: state.certificatePath!,
        availableTimeSlots: availabilityState.availability.availableTimeSlots
      ),
    );
        BlocProvider.of<AvailabilityBloc>(context).add(const ResetAvailability());

    // await _showSubmissionDialog(context);
    await DialogService.showSubmissionDialog(
      context,
      onSuccess: () {
        DialogService.showSuccessDialog(
          context,
          profileBloc.state.profile.email,
        );
        _navigateToWelcome(context);
      },
      onError: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }

  void _navigateToWelcome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Registration Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your account is pending admin approval.'),
            const Text('You will receive an email when approved.'),
            const SizedBox(height: 20),
            // Text('Reference Email: $email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSubmissionSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
          'Data is submitted. You can login once the admin approves your account.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void uploadCertificate(String filePath) {
    certificateBloc.add(UploadCertificateEvent(filePath));
  }

  void submitCertificate() {
    certificateBloc.add(SubmitCertificateEvent());
  }
}
