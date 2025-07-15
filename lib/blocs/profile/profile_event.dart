import 'dart:io';

import 'package:image_picker/image_picker.dart';

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

class UpdatePassword extends ProfileEvent{
  final String password;
  UpdatePassword(this.password);
}

class UpdateConfirmPassword extends ProfileEvent {
  final String confirmPassword;
  UpdateConfirmPassword(this.confirmPassword);
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

class CaptureImage extends ProfileEvent {
  final ImageSource source;
  CaptureImage({this.source = ImageSource.gallery});
}

class ImageCaptured extends ProfileEvent {
  final File imageFile;
  ImageCaptured(this.imageFile);
}

class TogglePasswordVisibility extends ProfileEvent{}
