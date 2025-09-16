
// abstract class DoctorProfileEvent {

//   const DoctorProfileEvent();
//   // Existing events...
//    factory DoctorProfileEvent.fetchProfile(String doctorId) = FetchProfile;
// }

// class ProfileImageUpdateRequested extends DoctorProfileEvent {}
// class ProfileNameUpdateRequested extends DoctorProfileEvent {
//   final String newValue;
//   ProfileNameUpdateRequested(this.newValue);
// }
// class ProfileExperienceUpdateRequested extends DoctorProfileEvent {
//   final String newValue;
//   ProfileExperienceUpdateRequested(this.newValue);
// }
// class ProfileEmailUpdateRequested extends DoctorProfileEvent {
//   final String newValue;
//   ProfileEmailUpdateRequested(this.newValue);
// }
// class ProfileSpecializationUpdateRequested extends DoctorProfileEvent {
//   final String newValue;
//   ProfileSpecializationUpdateRequested(this.newValue);
// }
// class ProfilePhoneUpdateRequested extends DoctorProfileEvent {
//   final String newValue;
//   ProfilePhoneUpdateRequested(this.newValue);
// }

// class FetchProfile extends DoctorProfileEvent{
//   final String doctorId;
//    FetchProfile(this.doctorId);

  
// }


// import 'package:equatable/equatable.dart';

// abstract class DoctorProfileEvent extends Equatable {
//   const DoctorProfileEvent();

//   @override
//   List<Object?> get props => [];
// }

// // Event to request updating the profile image
// class ProfileImageUpdateRequested extends DoctorProfileEvent {
//   const ProfileImageUpdateRequested();

//   @override
//   List<Object?> get props => [];
// }

// // Event to request updating the full name
// class ProfileNameUpdateRequested extends DoctorProfileEvent {
//   final String newValue;

//   const ProfileNameUpdateRequested(this.newValue);

//   @override
//   List<Object?> get props => [newValue];
// }

// // Event to request updating the experience
// class ProfileExperienceUpdateRequested extends DoctorProfileEvent {
//   final String newValue;

//   const ProfileExperienceUpdateRequested(this.newValue);

//   @override
//   List<Object?> get props => [newValue];
// }

// // Event to request updating the email
// class ProfileEmailUpdateRequested extends DoctorProfileEvent {
//   final String newValue;

//   const ProfileEmailUpdateRequested(this.newValue);

//   @override
//   List<Object?> get props => [newValue];
// }

// // Event to request updating the specialization
// class ProfileSpecializationUpdateRequested extends DoctorProfileEvent {
//   final String newValue;

//   const ProfileSpecializationUpdateRequested(this.newValue);

//   @override
//   List<Object?> get props => [newValue];
// }

// // Event to request updating the phone number
// class ProfilePhoneUpdateRequested extends DoctorProfileEvent {
//   final String newValue;

//   const ProfilePhoneUpdateRequested(this.newValue);

//   @override
//   List<Object?> get props => [newValue];
// }

// // Event to fetch profile data for a specific doctor ID
// class FetchProfile extends DoctorProfileEvent {
//   final String? doctorId;

//   const FetchProfile(this.doctorId);

//   @override
//   List<Object?> get props => [doctorId];
// }

import 'package:equatable/equatable.dart';

abstract class DoctorProfileEvent extends Equatable {
  const DoctorProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfile extends DoctorProfileEvent {
  final String? doctorId;

  const FetchProfile(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

class ProfileNameUpdateRequested extends DoctorProfileEvent {
  final String newValue;

  const ProfileNameUpdateRequested(this.newValue);

  @override
  List<Object?> get props => [newValue];
}

class ProfileExperienceUpdateRequested extends DoctorProfileEvent {
  final String newValue;

  const ProfileExperienceUpdateRequested(this.newValue);

  @override
  List<Object?> get props => [newValue];
}

class ProfilePhoneUpdateRequested extends DoctorProfileEvent {
  final String newValue;

  const ProfilePhoneUpdateRequested(this.newValue);

  @override
  List<Object?> get props => [newValue];
}

class ProfileEmailUpdateRequested extends DoctorProfileEvent {
  final String newValue;

  const ProfileEmailUpdateRequested(this.newValue);

  @override
  List<Object?> get props => [newValue];
}

class ProfileSpecializationUpdateRequested extends DoctorProfileEvent {
  final String newValue;

  const ProfileSpecializationUpdateRequested(this.newValue);

  @override
  List<Object?> get props => [newValue];
}

class ProfileImageUpdateRequested extends DoctorProfileEvent {
  const ProfileImageUpdateRequested();

  @override
  List<Object?> get props => [];
}