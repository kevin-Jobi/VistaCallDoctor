
import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vista_call_doctor/config.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../models/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ImagePicker _imagePicker;
  ProfileBloc({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker(),
      super(ProfileState(profile: ProfileModel())) {
    on<UpdateFullName>((event, emit) {
      final updatedProfile = state.profile.copyWith(fullName: event.fullName);
      emit(state.copyWith(profile: updatedProfile));
    });
    on<UpdateAge>((event, emit) {
      final updatedProfile = state.profile.copyWith(age: event.age);
      emit(state.copyWith(profile: updatedProfile));
    });
    on<UpdateDateOfBirth>((event, emit) {
      final updatedProfile = state.profile.copyWith(
        dateOfBirth: event.dateOfBirth,
      );
      emit(state.copyWith(profile: updatedProfile));
    });
    on<UpdateEmail>((event, emit) {
      final updatedProfile = state.profile.copyWith(email: event.email);
      emit(state.copyWith(profile: updatedProfile));
    });
    on<UpdatePassword>((event, emit) {
      final updatedProfile = state.profile.copyWith(password: event.password);
      emit(state.copyWith(profile: updatedProfile));
    });
    on<UpdateConfirmPassword>((event, emit) {
      final updatedProfile = state.profile.copyWith(
        confirmPassword: event.confirmPassword,
      );
      emit(state.copyWith(profile: updatedProfile));
    });

    on<UpdateGender>((event, emit) {
      final updatedProfile = state.profile.copyWith(gender: event.gender);
      emit(state.copyWith(profile: updatedProfile));
    });
    on<UpdateDepartment>((event, emit) {
      final updatedProfile = state.profile.copyWith(
        department: event.department,
      );
      emit(state.copyWith(profile: updatedProfile));
    });
    on<UpdateHospitalName>((event, emit) {
      final updatedProfile = state.profile.copyWith(
        hospitalName: event.hospitalName,
      );
      emit(state.copyWith(profile: updatedProfile));
    });
    on<SubmitProfile>((event, emit) {
      emit(state.copyWith(isSubmitting: true));
      // Simulate success
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    });
    on<FetchDepartmentsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final response = await http.get(
          Uri.parse('https://api.example.com/departments'),
        );
        if (response.statusCode == 200) {
          final departments = parseDepartments(response.body); // Custom parser
          emit(state.copyWith(isLoading: false, departments: departments));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              error: 'Failed to load departments',
            ),
          );
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
    on<CaptureImage>(_onCaptureImage);
    on<ImageCaptured>(_onImageCaptured);

    on<TogglePasswordVisibility>((event,emit){
      emit(state.copyWith(
        isPasswordVisible: !state.isPasswordVisible
      ));
    });
  }

  List<String> parseDepartments(String responseBody) {
    // Placeholder parser - adjust based on your API response
    return responseBody.split(','); // Example: "dept1,dept2,dept3"
  }

  Future<void> _onCaptureImage(
    CaptureImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, // or camera
        imageQuality: 85,
      );
      if (pickedFile != null) {
        add(ImageCaptured(File(pickedFile.path)));
        final response = await cloudinary.upload(
          file: pickedFile.path,
          resourceType: CloudinaryResourceType.image,
          folder: 'profile'
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: "Failed to capture image:${e.toString()}",
        ),
      );
    }
  }

  void _onImageCaptured(ImageCaptured event, Emitter<ProfileState> emit) {
    final updateProfile = state.profile.copyWith(profileImage: event.imageFile);
    emit(state.copyWith(profile: updateProfile, isLoading: false));
  }
}