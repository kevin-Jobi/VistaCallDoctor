import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_event.dart';
import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_state.dart';
import 'package:vista_call_doctor/blocs/profile/profile_state.dart';
import 'package:vista_call_doctor/services/cloudinary_service.dart';
import 'package:vista_call_doctor/view_models/doctor_profile_view_model.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final AuthBloc authBloc;
  final DoctorProfileViewModel viewModel;
  final ImagePicker _picker = ImagePicker();
  final CloudinaryService _cloudinary = CloudinaryService();

  DoctorProfileBloc({required this.authBloc})
    : viewModel = DoctorProfileViewModel(authBloc),
      super(DoctorProfileState()) {
    on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
    on<ProfileNameUpdateRequested>(_onProfileNameUpdateRequested);
    on<ProfileExperienceUpdateRequested>(_onProfileExperienceUpdateRequested);
    on<ProfileEmailUpdateRequested>(_onProfileEmailUpdateRequested);
    on<ProfileSpecializationUpdateRequested>(
      _onProfileSpecializationUpdateRequested,
    );
    on<ProfilePhoneUpdateRequested>(_onProfilePhoneUpdateRequested);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final data = await viewModel.getDoctorDetails();
    final personal = data['personal'] as Map<String, dynamic>? ?? {};
    final availability = data['availability'] as Map<String, dynamic>? ?? {};

    final initialImageUrl = personal['profileImageUrl']?.toString();
    if (initialImageUrl != null) {
      emit(
        state.copyWith(
          profileImageUrl: personal['profileImageUrl']?.toString(),
          fullName: personal['fullName']?.toString() ?? 'Najin',
          experience:
              availability['yearsOfExperience']?.toString() ?? '12 years',
          phone: personal['phone']?.toString() ?? '+91 80866 38332',
          email: personal['email']?.toString() ?? 'najin007@gmail.com',
          specialization: personal['department']?.toString() ?? 'dermatologist',
        ),
      );
    }
  }

  Future<void> _onProfileImageUpdateRequested(
    ProfileImageUpdateRequested event,
    Emitter<DoctorProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    try {
      final newImageUrl = await _cloudinary.uploadFile(
        filePath: image.path,
        folder: 'doctor-profiles',
      );
      await viewModel.updateProfileImage(newImageUrl);
      emit(state.copyWith(profileImageUrl: newImageUrl, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update image:$e',
        ),
      );
    }
  }

  Future<void> _onProfileNameUpdateRequested(ProfileNameUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await viewModel.updateName(event.newValue);
      emit(state.copyWith(fullName: event.newValue, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update name: $e'));
    }
  }

  Future<void> _onProfileExperienceUpdateRequested(ProfileExperienceUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await viewModel.updateExperience(event.newValue);
      emit(state.copyWith(experience: event.newValue, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update experience: $e'));
    }
  }

  Future<void> _onProfileEmailUpdateRequested(ProfileEmailUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await viewModel.updateEmail(event.newValue);
      emit(state.copyWith(email: event.newValue, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update email: $e'));
    }
  }

  Future<void> _onProfileSpecializationUpdateRequested(ProfileSpecializationUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await viewModel.updateSpecialization(event.newValue);
      emit(state.copyWith(specialization: event.newValue, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update specialization: $e'));
    }
  }

  Future<void> _onProfilePhoneUpdateRequested(ProfilePhoneUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await viewModel.updatePhone(event.newValue);
      emit(state.copyWith(phone: event.newValue, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update phone: $e'));
    }
  }


}
