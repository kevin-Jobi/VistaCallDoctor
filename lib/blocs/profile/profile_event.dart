abstract class ProfileEvent {}

class UpdateFullName extends ProfileEvent {
  final String fullName;
  UpdateFullName(this.fullName);
}

class UpdateAge extends ProfileEvent {
  final String age;
  UpdateAge(this.age);
}

class UpdateDateOfBirth extends ProfileEvent {
  final String dateOfBirth;
  UpdateDateOfBirth(this.dateOfBirth);
}

class UpdateEmail extends ProfileEvent {
  final String email;
  UpdateEmail(this.email);
}

class UpdateGender extends ProfileEvent {
  final String gender;
  UpdateGender(this.gender);
}

class UpdateDepartment extends ProfileEvent {
  final String department;
  UpdateDepartment(this.department);
}

class UpdateHospitalName extends ProfileEvent {
  final String hospitalName;
  UpdateHospitalName(this.hospitalName);
}

class SubmitProfile extends ProfileEvent {}

class FetchDepartmentsEvent extends ProfileEvent {}
