
// class DoctorProfileState {
//   final String? profileImageUrl;
//   final String fullName;
//   final String experience;
//   final String phone;
//   final String email;
//   final String specialization;
//   final bool isLoading;
//   final String? errorMessage;
//   final String? doctorId;
//   final Map<String,dynamic> availability;

//   const DoctorProfileState({
//     this.profileImageUrl,
//     this.fullName = 'Najin',
//     this.experience = '12 years',
//     this.phone = '+91 80866 38332',
//     this.email = 'najin007@gmail.com',
//     this.specialization = 'dermatologist',
//     this.isLoading = false,
//     this.errorMessage,
//     this.doctorId,
//     this.availability = const {}
//   });

//   DoctorProfileState copyWith({
// bool? isLoading,
//     String? errorMessage,
//     String? profileImageUrl,
//     String? fullName,
//     String? experience,
//     String? phone,
//     String? email,
//     String? specialization,
//     String? doctorId,
//     Map<String, dynamic>? availability,
//   }) {
//     return DoctorProfileState(
// isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage ?? this.errorMessage,
//       profileImageUrl: profileImageUrl ?? this.profileImageUrl,
//       fullName: fullName ?? this.fullName,
//       experience: experience ?? this.experience,
//       phone: phone ?? this.phone,
//       email: email ?? this.email,
//       specialization: specialization ?? this.specialization,
//       doctorId: doctorId ?? this.doctorId,
//       availability: availability ?? this.availability,
//     );
//   }
// }


// import 'package:equatable/equatable.dart';

// class DoctorProfileState extends Equatable {
//   final bool isLoading;
//   final String? errorMessage;
//   final String? profileImageUrl;
//   final String fullName;
//   final String experience;
//   final String phone;
//   final String email;
//   final String specialization;
//   final String? doctorId; // New parameter
//   final Map<String, dynamic> availability; // New parameter

//   const DoctorProfileState({
//     this.isLoading = false,
//     this.errorMessage,
//     this.profileImageUrl,
//     this.fullName = 'Najin',
//     this.experience = '12 years',
//     this.phone = '+91 80866 38332',
//     this.email = 'najin007@gmail.com',
//     this.specialization = 'dermatologist',
//     this.doctorId,
//     this.availability = const {},
//   });

//   DoctorProfileState copyWith({
//     bool? isLoading,
//     String? errorMessage,
//     String? profileImageUrl,
//     String? fullName,
//     String? experience,
//     String? phone,
//     String? email,
//     String? specialization,
//     String? doctorId,
//     Map<String, dynamic>? availability,
//   }) {
//     return DoctorProfileState(
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage ?? this.errorMessage,
//       profileImageUrl: profileImageUrl ?? this.profileImageUrl,
//       fullName: fullName ?? this.fullName,
//       experience: experience ?? this.experience,
//       phone: phone ?? this.phone,
//       email: email ?? this.email,
//       specialization: specialization ?? this.specialization,
//       doctorId: doctorId ?? this.doctorId,
//       availability: availability ?? this.availability,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         isLoading,
//         errorMessage,
//         profileImageUrl,
//         fullName,
//         experience,
//         phone,
//         email,
//         specialization,
//         doctorId,
//         availability,
//       ];
// }


import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class DoctorProfileState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? fullName;
  final String? experience;
  final String? phone;
  final String? email;
  final String? specialization;
  final String? profileImageUrl;
  final Map<String, dynamic>? availability;

  const DoctorProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.fullName,
    this.experience,
    this.phone,
    this.email,
    this.specialization,
    this.profileImageUrl,
    this.availability,
  });

  DoctorProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? fullName,
    String? experience,
    String? phone,
    String? email,
    String? specialization,
    String? profileImageUrl,
    Map<String, dynamic>? availability,
  }) {
    return DoctorProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      fullName: fullName ?? this.fullName,
      experience: experience ?? this.experience,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      specialization: specialization ?? this.specialization,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      availability: availability ?? this.availability,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        fullName,
        experience,
        phone,
        email,
        specialization,
        profileImageUrl,
        availability,
      ];
}