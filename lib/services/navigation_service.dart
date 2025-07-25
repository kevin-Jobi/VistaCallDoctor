// services/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:vista_call_doctor/view_models/auth_wrapper.dart';
import 'package:vista_call_doctor/views/profile/components/profile.dart';

class NavigationService {
  static void navigateToProfileDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  static void navigateToAuthWrapper(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
      (route) => false,
    );
  }
}