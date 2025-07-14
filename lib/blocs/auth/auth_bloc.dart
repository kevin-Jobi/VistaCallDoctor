import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    // Listen to auth state changes
    on<AppStarted>((event, emit) async {
      print('AuthBloc: AppStarted - Listening to auth state changes');
      await emit.forEach<UserModel?>(
        authService.authStateChanges,
        onData: (user) {
          print(
            'AuthBloc: AuthState changed to ${user != null ? 'Authenticated' : 'Unauthenticated'}',
          );
          return user != null ? Authenticated(user) : Unauthenticated();
        },
      );
    });

    on<SignInWithGoogle>((event, emit) async {
      print('AuthBloc: SignInWithGoogle - Starting authentication');
      emit(AuthLoading());
      try {
        final user = await authService.signInWithGoogle();
        if (user != null) {
          print('AuthBloc: SignInWithGoogle - Success, emitting Authenticated');
          emit(Authenticated(user));
        } else {
          print(
            'AuthBloc: SignInWithGoogle - Failed, emitting Unauthenticated',
          );
          emit(Unauthenticated());
        }
      } catch (e) {
        print('AuthBloc: SignInWithGoogle - Error - $e');
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignOut>((event, emit) async {
      print('AuthBloc: SignOut - Starting logout');
      emit(AuthLoading());
      try {
        await authService.signOut();
        print('AuthBloc: SignOut - Success, emitting Unauthenticated');
        emit(Unauthenticated());
      } catch (e) {
        print('AuthBloc: SignOut - Error - $e');
        emit(AuthFailure(e.toString()));
      }
    });

    on<GetDepartmentEvent>((event, emit) async {
      log('AuthBloc: GetDepartmentEvent - Fetching departments');
      emit(GetDepartmentLoadingState());
      try {
        final DocumentSnapshot departmentDocument = await FirebaseFirestore
            .instance
            .collection('admin')
            .doc('adminC3d4E5f6G7h8I9j')
            .get();
        if (departmentDocument.exists) {
          final List<String> departments = List<String>.from(
            departmentDocument.get('categories') as List<dynamic>,
          );
          log('AuthBloc: GetDepartmentEvent - Departments fetched: $departments');
           emit(GetDepartmentLoadedState(departments));
        } else {
          log('AuthBloc: GetDepartmentEvent - No departments found');
          emit(GetDepartmentErrorState('No departments found'));
          return;
        }
        print(
          'AuthBloc: GetDepartmentEvent - Success, emitting GetDepartmentLoadedState',
        );
        
      } catch (e) {
        print('AuthBloc: GetDepartmentEvent - Error - $e');
        emit(GetDepartmentErrorState(e.toString()));
      }
    });
  }
}
