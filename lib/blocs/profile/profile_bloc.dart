import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'profile_event.dart';
import 'profile_state.dart';
import '../../models/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState(profile: ProfileModel())) {
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
  }

  List<String> parseDepartments(String responseBody) {
    // Placeholder parser - adjust based on your API response
    return responseBody.split(','); // Example: "dept1,dept2,dept3"
  }
}
