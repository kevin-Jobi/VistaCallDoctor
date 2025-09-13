
class DoctorProfileState {
  final String? profileImageUrl;
  final String fullName;
  final String experience;
  final String phone;
  final String email;
  final String specialization;
  final bool isLoading;
  final String? errorMessage;

  const DoctorProfileState({
    this.profileImageUrl,
    this.fullName = 'Najin',
    this.experience = '12 years',
    this.phone = '+91 80866 38332',
    this.email = 'najin007@gmail.com',
    this.specialization = 'dermatologist',
    this.isLoading = false,
    this.errorMessage,
  });

  DoctorProfileState copyWith({
    String? profileImageUrl,
    String? fullName,
    String? experience,
    String? phone,
    String? email,
    String? specialization,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DoctorProfileState(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      fullName: fullName ?? this.fullName,
      experience: experience ?? this.experience,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      specialization: specialization ?? this.specialization,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
