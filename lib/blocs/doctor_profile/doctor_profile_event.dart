
abstract class DoctorProfileEvent {}

class ProfileImageUpdateRequested extends DoctorProfileEvent {}
class ProfileNameUpdateRequested extends DoctorProfileEvent {
  final String newValue;
  ProfileNameUpdateRequested(this.newValue);
}
class ProfileExperienceUpdateRequested extends DoctorProfileEvent {
  final String newValue;
  ProfileExperienceUpdateRequested(this.newValue);
}
class ProfileEmailUpdateRequested extends DoctorProfileEvent {
  final String newValue;
  ProfileEmailUpdateRequested(this.newValue);
}
class ProfileSpecializationUpdateRequested extends DoctorProfileEvent {
  final String newValue;
  ProfileSpecializationUpdateRequested(this.newValue);
}
class ProfilePhoneUpdateRequested extends DoctorProfileEvent {
  final String newValue;
  ProfilePhoneUpdateRequested(this.newValue);
}