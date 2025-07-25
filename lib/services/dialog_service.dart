// services/dialog_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_bloc.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_state.dart';

class DialogService {

  static Future<void> showSubmissionDialog(BuildContext context, {
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          // const Text('Submitting your information...'),
          BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              // if (state is OnboardingSuccess) {
              //   Navigator.pop(context);
              //   onSuccess();
              // }
              if (state is OnboardingFailure) {
                Navigator.pop(context);
                onError(state.error);
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  static void showSuccessDialog(BuildContext context, String email) {
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
            Text('Reference Email: $email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showSubmissionSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
          'Data is submitted. You can login once the admin approves your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

    static Future<void> showCertificateSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Certificate Uploaded'),
        content: const Text('Your certificate was successfully uploaded.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

    static Future<bool?> showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}