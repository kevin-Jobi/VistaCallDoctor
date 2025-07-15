import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_event.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_state.dart';



class DoctorAuthBloc extends Bloc<DoctorAuthEvent, DoctorAuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DoctorAuthBloc({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore,
        super(DoctorAuthInitial()) {
    on<DoctorLoginRequested>(_onLoginRequested);
    on<DoctorLogoutRequested>(_onLogoutRequested);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<DoctorAuthState> emit
  ){
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
  Future<void> _onLoginRequested(
    DoctorLoginRequested event,
    Emitter<DoctorAuthState> emit,
  ) async {
    emit(DoctorAuthLoading());
    try {
      // 1. Authenticate with email/password
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // 2. Check if doctor is approved
      final doctorDoc = await _firestore
          .collection('doctors')
          .doc(userCredential.user!.uid)
          .get();

      if (!doctorDoc.exists) {
        await _auth.signOut();
        emit(DoctorAuthFailure('Doctor record not found'));
        return;
      }

      final status = doctorDoc.data()?['verificationStatus'] ?? 'pending';
      if (status != 'approved') {
        await _auth.signOut();
        emit(DoctorAuthFailure('Account not approved by admin yet'));
        return;
      }

      emit(DoctorAuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(DoctorAuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      emit(DoctorAuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    DoctorLogoutRequested event,
    Emitter<DoctorAuthState> emit,
  ) async {
    await _auth.signOut();
    emit(DoctorAuthInitial());
  }
}