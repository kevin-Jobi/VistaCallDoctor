// class ProfileModel {
//   final String fullName;
//   final String age;
//   final String dateOfBirth;
//   final String email;
//   final String gender;
//   final String hospitalName;

//   ProfileModel({
//     this.fullName = '',
//     this.age = '',
//     this.dateOfBirth = '',
//     this.email = '',
//     this.gender = '',
//     this.hospitalName = '',
//   });

//   ProfileModel copyWith({
//     String? fullName,
//     String? age,
//     String? dateOfBirth,
//     String? email,
//     String? gender,
//     String? hospitalName,
//   }) {
//     return ProfileModel(
//       fullName: fullName ?? this.fullName,
//       age: age ?? this.age,
//       dateOfBirth: dateOfBirth ?? this.dateOfBirth,
//       email: email ?? this.email,
//       gender: gender ?? this.gender,
//       hospitalName: hospitalName ?? this.hospitalName,
//     );
//   }
// }

// ---------------------------------------------------------



// import 'dart:io';

// class ProfileModel {
//   final String fullName;
//   final String age;
//   final String dateOfBirth;
//   final String email;
//   final String password;
//   final String confirmPassword;
//   final String gender;
//   final String department;
//   final String hospitalName;
//   final File? profileImage;
//   final String? profileImageUrl;

//   ProfileModel({
//     this.fullName = '',
//     this.age = '',
//     this.dateOfBirth = '',
//     this.email = '',
//     this.password = '',
//     this.confirmPassword = '',
//     this.gender = '',
//     this.department = '',
//     this.hospitalName = '',
//     this.profileImage,
//     this.profileImageUrl
//   });

//   ProfileModel copyWith({
//     String? fullName,
//     String? age,
//     String? dateOfBirth,
//     String? email,
//     String? password,
//     String? confirmPassword,
//     String? gender,
//     String? department,
//     String? hospitalName,
//     File? profileImage,
//     String? profileImageUrl
//   }) {
//     return ProfileModel(
//       fullName: fullName ?? this.fullName,
//       age: age ?? this.age,
//       dateOfBirth: dateOfBirth ?? this.dateOfBirth,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       confirmPassword: confirmPassword ?? this.confirmPassword,
//       gender: gender ?? this.gender,
//       department: department ?? this.department,
//       hospitalName: hospitalName ?? this.hospitalName,
//       profileImage: profileImage ?? this.profileImage,
//       profileImageUrl: profileImageUrl ?? this.profileImageUrl
//     );
//   }
// }



import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String fullName;
  final String age;
  final String dateOfBirth;
  final String email;
  final String password; // Will be hashed before storage
  final String confirmPassword; // Not stored, just for validation
  final String gender;
  final String department;
  final String hospitalName;
  final File? profileImage; // Local file - not stored directly
  final String? profileImageUrl; // Cloudinary URL after upload
  final List<String> availableDays;
  final String yearsOfExperience;
  final String fees;
  final String? certificatePath; // Local file path
  final String? certificateUrl; // Cloudinary URL after upload
  final String verificationStatus; // 'pending', 'approved', 'rejected'
  final Timestamp? createdAt;

  const ProfileModel({
    this.fullName = '',
    this.age = '',
    this.dateOfBirth = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.gender = '',
    this.department = '',
    this.hospitalName = '',
    this.profileImage,
    this.profileImageUrl,
    this.availableDays = const [],
    this.yearsOfExperience = '',
    this.fees = '',
    this.certificatePath,
    this.certificateUrl,
    this.verificationStatus = 'pending',
    this.createdAt,
  });

  // Convert to Firestore-friendly map
  Map<String, dynamic> toFirestore() {
    return {
      'personal': {
        'fullName': fullName,
        'age': age,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'gender': gender,
        'department': department,
        'hospitalName': hospitalName,
        'profileImageUrl': profileImageUrl,
      },
      'availability': {
        'availableDays': availableDays,
        'yearsOfExperience': yearsOfExperience,
        'fees': fees,
      },
      'certificateUrl': certificateUrl,
      'password': password, // Note: Should be hashed
      'verificationStatus': verificationStatus,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory ProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final personal = data['personal'] as Map<String, dynamic>;
    final availability = data['availability'] as Map<String, dynamic>;

    return ProfileModel(
      fullName: personal['fullName'] ?? '',
      age: personal['age'] ?? '',
      dateOfBirth: personal['dateOfBirth'] ?? '',
      email: personal['email'] ?? '',
      gender: personal['gender'] ?? '',
      department: personal['department'] ?? '',
      hospitalName: personal['hospitalName'] ?? '',
      profileImageUrl: personal['profileImageUrl'],
      availableDays: List<String>.from(availability['availableDays'] ?? []),
      yearsOfExperience: availability['yearsOfExperience'] ?? '',
      fees: availability['fees'] ?? '',
      certificateUrl: data['certificateUrl'],
      verificationStatus: data['verificationStatus'] ?? 'pending',
      createdAt: data['createdAt'],
    );
  }

  // For updating individual fields
  ProfileModel copyWith({
    String? fullName,
    String? age,
    String? dateOfBirth,
    String? email,
    String? password,
    String? confirmPassword,
    String? gender,
    String? department,
    String? hospitalName,
    File? profileImage,
    String? profileImageUrl,
    List<String>? availableDays,
    String? yearsOfExperience,
    String? fees,
    String? certificatePath,
    String? certificateUrl,
    String? verificationStatus,
    Timestamp? createdAt,
  }) {
    return ProfileModel(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      gender: gender ?? this.gender,
      department: department ?? this.department,
      hospitalName: hospitalName ?? this.hospitalName,
      profileImage: profileImage ?? this.profileImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      availableDays: availableDays ?? this.availableDays,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      fees: fees ?? this.fees,
      certificatePath: certificatePath ?? this.certificatePath,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // For form validation
  bool get isProfileComplete {
    return fullName.isNotEmpty &&
        age.isNotEmpty &&
        dateOfBirth.isNotEmpty &&
        email.isNotEmpty &&
        gender.isNotEmpty &&
        department.isNotEmpty &&
        hospitalName.isNotEmpty;
  }

  bool get isAvailabilityComplete {
    return availableDays.isNotEmpty &&
        yearsOfExperience.isNotEmpty &&
        fees.isNotEmpty;
  }

  bool get isCertificateComplete {
    return certificatePath != null || certificateUrl != null;
  }

  bool get isPasswordValid {
    return password.length >= 8 &&
        password == confirmPassword &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }
}