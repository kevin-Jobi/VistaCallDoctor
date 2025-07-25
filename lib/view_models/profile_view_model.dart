// import '../blocs/profile/profile_bloc.dart';
// import '../blocs/profile/profile_event.dart';

// class ProfileViewModel {
//   final ProfileBloc profileBloc;

//   ProfileViewModel(this.profileBloc);

//   void updateFullName(String fullName) {
//     profileBloc.add(UpdateFullName(fullName));
//   }

//   void updateAge(String age) {
//     profileBloc.add(UpdateAge(age));
//   }

//   void updateDateOfBirth(String dateOfBirth) {
//     profileBloc.add(UpdateDateOfBirth(dateOfBirth));
//   }

//   void updateEmail(String email) {
//     profileBloc.add(UpdateEmail(email));
//   }

//   void updatePassword(String password){
//     profileBloc.add(UpdatePassword(password));
//   }

//   void updateConfirmPassword(String confirmPassword){
//     profileBloc.add(UpdateConfirmPassword(confirmPassword));
//   }

//   void updateGender(String gender) {
//     profileBloc.add(UpdateGender(gender));
//   }

//   void updateDepartment(String department) {
//     profileBloc.add(UpdateDepartment(department));
//   }

//   void updateHospitalName(String hospitalName) {
//     profileBloc.add(UpdateHospitalName(hospitalName));
//   }

//   void submitProfile() {
//     profileBloc.add(SubmitProfile());
//   }
// }


// view_models/doctor_profile_view_model.dart
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_event.dart';

class DoctorProfileViewModel {
  final AuthBloc authBloc;

  DoctorProfileViewModel(this.authBloc);

  void logout() {
    authBloc.add(SignOut());
  }

  // Add other business logic methods here
  // For example:
  // - fetchProfileData()
  // - updateProfile()
  // - Any data transformations
}