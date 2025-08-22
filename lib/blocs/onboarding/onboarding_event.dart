import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class SubmitOnboarding extends OnboardingEvent {
  final String fullName;
  final String age;
  final String dateOfBirth;
  final String email;
  final String password;
  final String gender;
  final String department;
  final String hospitalName;
  final File? profileImage;
  final List<String> availableDays;
  final String yearsOfExperience;
  final String fees;
  final Map<String,List<String>> availableTimeSlots;
  final String certificatePath;

  const SubmitOnboarding({
    required this.fullName,
    required this.age,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.gender,
    required this.department,
    required this.hospitalName,
    this.profileImage,
    required this.availableDays,
    required this.yearsOfExperience,
    required this.fees,
    required this.certificatePath,
    required this.availableTimeSlots
  });

  @override
  List<Object> get props => [
        fullName,
        age,
        dateOfBirth,
        email,
        password,
        gender,
        department,
        hospitalName,
        availableDays,
        yearsOfExperience,
        fees,
        certificatePath,
        availableTimeSlots
      ];
}