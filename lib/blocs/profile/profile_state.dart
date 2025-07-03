import 'package:equatable/equatable.dart';
import '../../models/profile_model.dart';

class ProfileState extends Equatable {
  final ProfileModel profile;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isLoading;
  final List<String>? departments;
  final String? error;

  const ProfileState({
    required this.profile,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isLoading = false,
    this.departments,
    this.error,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isLoading,
    List<String>? departments,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
      departments: departments ?? this.departments,
      error: error ?? this.error,
    );
  }

  static ProfileState initial() {
    return ProfileState(profile: ProfileModel());
  }

  @override
  List<Object?> get props => [
    profile,
    isSubmitting,
    isSuccess,
    isLoading,
    departments,
    error,
  ];
}
