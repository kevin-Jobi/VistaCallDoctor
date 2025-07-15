import 'package:equatable/equatable.dart';
import '../../models/profile_model.dart';

class ProfileState extends Equatable {
  final ProfileModel profile;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isLoading;
  final bool isImageLoading; // specific loading state for image operations
  final List<String>? departments;
  final String? error;
  final String? imageError; // specific error for image operations
  final bool isPasswordVisible;

  const ProfileState({
    required this.profile,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isLoading = false,
    this.isImageLoading=false,
    this.departments,
    this.error,
    this.imageError,
    this.isPasswordVisible = false
  });

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isLoading,
    bool? isImageLoading,
    List<String>? departments,
    String? error,
    String? imageError,
    bool? isPasswordVisible
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
      isImageLoading: isImageLoading?? this.isImageLoading,
      departments: departments ?? this.departments,
      error: error ?? this.error,
      imageError: imageError ?? this.imageError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible
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
    isImageLoading,
    departments,
    error,
    imageError,
    isPasswordVisible
  ];
}
