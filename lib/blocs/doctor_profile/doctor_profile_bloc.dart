// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_event.dart';
// import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_state.dart';
// import 'package:vista_call_doctor/blocs/profile/profile_state.dart';
// import 'package:vista_call_doctor/services/cloudinary_service.dart';
// import 'package:vista_call_doctor/view_models/doctor_profile_view_model.dart';

// class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
//   final AuthBloc authBloc;
//   final DoctorProfileViewModel viewModel;
//   final ImagePicker _picker = ImagePicker();
//   final CloudinaryService _cloudinary = CloudinaryService();

//   DoctorProfileBloc({required this.authBloc})
//     : viewModel = DoctorProfileViewModel(authBloc),
//       super(DoctorProfileState()) {
//     on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
//     on<ProfileNameUpdateRequested>(_onProfileNameUpdateRequested);
//     on<ProfileExperienceUpdateRequested>(_onProfileExperienceUpdateRequested);
//     on<ProfileEmailUpdateRequested>(_onProfileEmailUpdateRequested);
//     on<ProfileSpecializationUpdateRequested>(
//       _onProfileSpecializationUpdateRequested,
//     );
//     on<ProfilePhoneUpdateRequested>(_onProfilePhoneUpdateRequested);
//     _loadInitialData();
//     on<FetchProfile>(_onFetchProfile);
//   }

//   Future<void> _onFetchProfile(
//     FetchProfile event,
//     Emitter<DoctorProfileState> emit,
//   )async{
//     emit(state.copyWith(isLoading: true));
//     try{
//       final data = await viewModel.getDoctorDetails(doctorId: event.doctorId);
//       emit(state.copyWith(
//         isLoading: false,
//         fullName: data['personal']['fullName'] ?? '',
//         experience: data['personal']['experience'] ?? '',
//         phone: data['personal']['phone'] ?? '',
//         email: data['personal']['email'] ?? '',
//         specialization: data['personal']['specialization'] ?? '',
//         profileImageUrl: data['personal']['profileImageUrl'] as String?,
//         availability: data['availability'] ?? {},
//       ));
//     }catch(e){
//       emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
//     }
//   }

//   Future<void> _loadInitialData() async {
//     final data = await viewModel.getDoctorDetails();
//     final personal = data['personal'] as Map<String, dynamic>? ?? {};
//     final availability = data['availability'] as Map<String, dynamic>? ?? {};

//     final initialImageUrl = personal['profileImageUrl']?.toString();
//     if (initialImageUrl != null) {
//       emit(
//         state.copyWith(
//           profileImageUrl: personal['profileImageUrl']?.toString(),
//           fullName: personal['fullName']?.toString() ?? 'Najin',
//           experience:
//               availability['yearsOfExperience']?.toString() ?? '12 years',
//           phone: personal['phone']?.toString() ?? '+91 80866 38332',
//           email: personal['email']?.toString() ?? 'najin007@gmail.com',
//           specialization: personal['department']?.toString() ?? 'dermatologist',
//         ),
//       );
//     }
//   }

//   Future<void> _onProfileImageUpdateRequested(
//     ProfileImageUpdateRequested event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image == null) {
//       emit(state.copyWith(isLoading: false));
//       return;
//     }

//     try {
//       final newImageUrl = await _cloudinary.uploadFile(
//         filePath: image.path,
//         folder: 'doctor-profiles',
//       );
//       await viewModel.updateProfileImage(newImageUrl);
//       emit(state.copyWith(profileImageUrl: newImageUrl, isLoading: false));
//     } catch (e) {
//       emit(
//         state.copyWith(
//           isLoading: false,
//           errorMessage: 'Failed to update image:$e',
//         ),
//       );
//     }
//   }

//   Future<void> _onProfileNameUpdateRequested(ProfileNameUpdateRequested event, Emitter<DoctorProfileState> emit) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateName(event.newValue);
//       emit(state.copyWith(fullName: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update name: $e'));
//     }
//   }

//   Future<void> _onProfileExperienceUpdateRequested(ProfileExperienceUpdateRequested event, Emitter<DoctorProfileState> emit) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateExperience(event.newValue);
//       emit(state.copyWith(experience: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update experience: $e'));
//     }
//   }

//   Future<void> _onProfileEmailUpdateRequested(ProfileEmailUpdateRequested event, Emitter<DoctorProfileState> emit) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateEmail(event.newValue);
//       emit(state.copyWith(email: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update email: $e'));
//     }
//   }

//   Future<void> _onProfileSpecializationUpdateRequested(ProfileSpecializationUpdateRequested event, Emitter<DoctorProfileState> emit) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateSpecialization(event.newValue);
//       emit(state.copyWith(specialization: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update specialization: $e'));
//     }
//   }

//   Future<void> _onProfilePhoneUpdateRequested(ProfilePhoneUpdateRequested event, Emitter<DoctorProfileState> emit) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updatePhone(event.newValue);
//       emit(state.copyWith(phone: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update phone: $e'));
//     }
//   }


// }




// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
// import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_event.dart';
// import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_state.dart';
// import 'package:vista_call_doctor/blocs/profile/profile_state.dart';
// import 'package:vista_call_doctor/services/cloudinary_service.dart';
// import 'package:vista_call_doctor/view_models/doctor_profile_view_model.dart';

// class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
//   final AuthBloc authBloc;
//   final DoctorProfileViewModel viewModel;
//   final ImagePicker _picker = ImagePicker();
//   final CloudinaryService _cloudinary = CloudinaryService();
//   // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   // final FirebaseAuth _auth = FirebaseAuth.instance;

//   DoctorProfileBloc({required this.authBloc})
//       : viewModel = DoctorProfileViewModel(authBloc),
//         super(DoctorProfileState()) {
//     on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
//     on<ProfileNameUpdateRequested>(_onProfileNameUpdateRequested);
//     on<ProfileExperienceUpdateRequested>(_onProfileExperienceUpdateRequested);
//     on<ProfileEmailUpdateRequested>(_onProfileEmailUpdateRequested);
//     on<ProfileSpecializationUpdateRequested>(
//       _onProfileSpecializationUpdateRequested,
//     );
//     on<ProfilePhoneUpdateRequested>(_onProfilePhoneUpdateRequested);
//     _loadInitialData();
//     on<FetchProfile>(_onFetchProfile);
//   }

//   Future<void> _onFetchProfile(
//     FetchProfile event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       final data = await viewModel.getDoctorDetails(); // Remove doctorId parameter
//       emit(state.copyWith(
//         isLoading: false,
//         fullName: data['personal']['fullName'] ?? '',
//         experience: data['personal']['experience'] ?? '',
//         phone: data['personal']['phone'] ?? '',
//         email: data['personal']['email'] ?? '',
//         specialization: data['personal']['department'] ?? '',
//         profileImageUrl: data['personal']['profileImageUrl'] as String?,
//         availability: data['availability'] ?? {},
//       ));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
//     }
//   }

//   Future<void> _loadInitialData() async {
//     final user = authBloc.state;
//     // No need to derive doctorId here since viewModel handles it
//     final data = await viewModel.getDoctorDetails(); // Remove doctorId parameter
//     final personal = data['personal'] as Map<String, dynamic>? ?? {};
//     final availability = data['availability'] as Map<String, dynamic>? ?? {};

//     final initialImageUrl = personal['profileImageUrl']?.toString();
//     if (initialImageUrl != null) {
//       emit(
//         state.copyWith(
//           profileImageUrl: personal['profileImageUrl']?.toString(),
//           fullName: personal['fullName']?.toString() ?? 'Najin',
//           experience: availability['yearsOfExperience']?.toString() ?? '12 years',
//           phone: personal['phone']?.toString() ?? '+91 80866 38332',
//           email: personal['email']?.toString() ?? 'najin007@gmail.com',
//           specialization: personal['department']?.toString() ?? 'dermatologist',
//           availability: availability,
//         ),
//       );
//     }
//   }

//   Future<void> _onProfileImageUpdateRequested(
//     ProfileImageUpdateRequested event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image == null) {
//       emit(state.copyWith(isLoading: false));
//       return;
//     }

//     try {
//       final newImageUrl = await _cloudinary.uploadFile(
//         filePath: image.path,
//         folder: 'doctor-profiles',
//       );
//       await viewModel.updateProfileImage(newImageUrl);
//       emit(state.copyWith(profileImageUrl: newImageUrl, isLoading: false));
//     } catch (e) {
//       emit(
//         state.copyWith(
//           isLoading: false,
//           errorMessage: 'Failed to update image:$e',
//         ),
//       );
//     }
//   }

//   Future<void> _onProfileNameUpdateRequested(
//     ProfileNameUpdateRequested event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateName(event.newValue);
//       emit(state.copyWith(fullName: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update name: $e'));
//     }
//   }

//   Future<void> _onProfileExperienceUpdateRequested(
//     ProfileExperienceUpdateRequested event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateExperience(event.newValue);
//       emit(state.copyWith(experience: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update experience: $e'));
//     }
//   }

//   Future<void> _onProfileEmailUpdateRequested(
//     ProfileEmailUpdateRequested event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateEmail(event.newValue);
//       emit(state.copyWith(email: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update email: $e'));
//     }
//   }

//   Future<void> _onProfileSpecializationUpdateRequested(
//     ProfileSpecializationUpdateRequested event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updateSpecialization(event.newValue);
//       emit(state.copyWith(specialization: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update specialization: $e'));
//     }
//   }

//   Future<void> _onProfilePhoneUpdateRequested(
//     ProfilePhoneUpdateRequested event,
//     Emitter<DoctorProfileState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     try {
//       await viewModel.updatePhone(event.newValue);
//       emit(state.copyWith(phone: event.newValue, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update phone: $e'));
//     }
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/models/user_model.dart';
import 'doctor_profile_state.dart';
import 'doctor_profile_event.dart';

class DoctorProfileBloc
    extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final AuthBloc authBloc;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DoctorProfileBloc({required this.authBloc})
      : super(const DoctorProfileState()) {
    on<FetchProfile>(_onFetchProfile);
    on<ProfileNameUpdateRequested>(_onProfileNameUpdateRequested);
    on<ProfileExperienceUpdateRequested>(_onProfileExperienceUpdateRequested);
    on<ProfilePhoneUpdateRequested>(_onProfilePhoneUpdateRequested);
    on<ProfileEmailUpdateRequested>(_onProfileEmailUpdateRequested);
    on<ProfileSpecializationUpdateRequested>(
        _onProfileSpecializationUpdateRequested);
    on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
  }

  Future<void> _onFetchProfile(
      FetchProfile event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        final data = doc.data() ?? {};
        final personal = data['personal'] ?? {};
        final availability = data['availability'] ?? {};
        emit(state.copyWith(
          isLoading: false,
          fullName: personal['fullName'] as String? ?? state.fullName,
          experience: availability['yearsOfExperience'] as String? ?? state.experience,
          phone: personal['phone'] as String? ?? state.phone,
          email: personal['email'] as String? ?? state.email,
          specialization: personal['department'] as String? ?? state.specialization,
          profileImageUrl: personal['profileImageUrl'] as String? ?? state.profileImageUrl,
          availability: availability,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Profile data not found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch profile: $e',
      ));
    }
  }

  Future<void> _onProfileNameUpdateRequested(
      ProfileNameUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.fullName': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        fullName: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update name: $e',
      ));
    }
  }

  Future<void> _onProfileExperienceUpdateRequested(
      ProfileExperienceUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'availability.yearsOfExperience': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        experience: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update experience: $e',
      ));
    }
  }

  Future<void> _onProfilePhoneUpdateRequested(
      ProfilePhoneUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.phone': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        phone: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update phone: $e',
      ));
    }
  }

  Future<void> _onProfileEmailUpdateRequested(
      ProfileEmailUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.email': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        email: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update email: $e',
      ));
    }
  }

  Future<void> _onProfileSpecializationUpdateRequested(
      ProfileSpecializationUpdateRequested event,
      Emitter<DoctorProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      final doctorId = user.uid;
      await _firestore.collection('doctors').doc(doctorId).update({
        'personal.department': event.newValue,
      });
      emit(state.copyWith(
        isLoading: false,
        specialization: event.newValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update specialization: $e',
      ));
    }
  }

  Future<void> _onProfileImageUpdateRequested(
      ProfileImageUpdateRequested event, Emitter<DoctorProfileState> emit) async {
    // Placeholder for image update logic
    emit(state.copyWith(isLoading: false));
  }
}