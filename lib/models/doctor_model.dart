// lib/models/doctor_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final PersonalInfo personal;
  final AvailabilityInfo availability;
  final String certificateUrl;
  final String password;
  final Timestamp createdAt;
  final String verificationStatus;

  Doctor({
    required this.personal,
    required this.availability,
    required this.certificateUrl,
    required this.password,
    required this.createdAt,
    this.verificationStatus = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'personal': personal.toMap(),
      'availability': availability.toMap(),
      'certificateUrl': certificateUrl,
      'password': password, // Note: Will be hashed after approval
      'createdAt': createdAt,
      'verificationStatus': verificationStatus,
    };
  }
}

class PersonalInfo {
  final String fullName;
  final String age;
  final String dateOfBirth;
  final String email;
  final String gender;
  final String department;
  final String hospitalName;
  final String? profileImageUrl;

  PersonalInfo({
    required this.fullName,
    required this.age,
    required this.dateOfBirth,
    required this.email,
    required this.gender,
    required this.department,
    required this.hospitalName,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'age': age,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'gender': gender,
      'department': department,
      'hospitalName': hospitalName,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class AvailabilityInfo {
  final List<String> availableDays;
  final String yearsOfExperience;
  final String fees;

  AvailabilityInfo({
    required this.availableDays,
    required this.yearsOfExperience,
    required this.fees,
  });

  Map<String, dynamic> toMap() {
    return {
      'availableDays': availableDays,
      'yearsOfExperience': yearsOfExperience,
      'fees': fees,
    };
  }
}