import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';
import '../../models/appointment_model.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppointmentBloc() : super(const AppointmentState()) {
    on<LoadAppointments>(_onLoadAppointments);
    // on<AcceptAppointment>(_onAcceptAppointment);
    // on<CancelAppointment>(_onCancelAppointment);
    on<CompleteAppointment>(_onCompleteAppointment);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, error: 'User not authenticated'));
        return;
      }
      // final db = FirebaseFirestore.instance;
      final doctorId = user.uid;
      final bookings = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('bookings')
          .orderBy('createdAt', descending: true)
          .get();
      print(
        'Raw appointments data: ${bookings.docs.map((doc) => doc.data()).toList()}',
      );
      final appointments = bookings.docs.map((doc) {
        final data = doc.data();
        String normalizedStatus = data['status']?.toLowerCase();
        if (normalizedStatus != 'completed') {
          normalizedStatus = 'upcoming'; // Default to Upcoming for new or invalid statuses
        }
        // return AppointmentModel.fromFirestore(doc.data(), doc.id);
        return AppointmentModel.fromFirestore({
          ...data,'status':normalizedStatus ,
        },doc.id);
      }).toList();

      print('Fetched appointments: $appointments');

      emit(state.copyWith(appointments: appointments, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load appointments: $e',
        ),
      );
    }
  }

  // void _onAcceptAppointment(
  //   AcceptAppointment event,
  //   Emitter<AppointmentState> emit,
  // ) async {
  //   emit(state.copyWith(isLoading: true));
  //   final updatedAppointments = List<AppointmentModel>.from(state.appointments);
  //   final appointmentToUpdate = updatedAppointments[event.index];
  //   final updatedAppointment = appointmentToUpdate.copyWith(status: 'Upcoming');

  //   // Update Firestore
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     final doctorId = user.uid;
  //     await _db
  //         .collection('doctors')
  //         .doc(doctorId)
  //         .collection('bookings')
  //         .doc(appointmentToUpdate.id)
  //         .update({'status': 'Upcoming'});
  //   }
  //   updatedAppointments[event.index] = updatedAppointment;
  //   emit(state.copyWith(appointments: updatedAppointments, isLoading: false));
  // }

  // void _onCancelAppointment(
  //   CancelAppointment event,
  //   Emitter<AppointmentState> emit,
  // ) async {
  //   emit(state.copyWith(isLoading: true));
  //   final updatedAppointments = List<AppointmentModel>.from(state.appointments);
  //   final appointmentToUpdate = updatedAppointments[event.index];
  //   final updatedAppointment = appointmentToUpdate.copyWith(status: 'Canceled');

  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     final doctorId = user.uid;
  //     await _db
  //         .collection('doctors')
  //         .doc(doctorId)
  //         .collection('bookings')
  //         .doc(appointmentToUpdate.id)
  //         .update({'status': 'Canceled'});
  //   }
  //   updatedAppointments[event.index] = updatedAppointment;
  //   emit(state.copyWith(appointments: updatedAppointments, isLoading: false));
  // }

  Future<void> _onCompleteAppointment(
    CompleteAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final updatedAppointments = List<AppointmentModel>.from(state.appointments);
    final appointmentToUpdate = updatedAppointments[event.index];
    final updatedAppointment = appointmentToUpdate.copyWith(
      status: 'Completed',
    );

    final user = _auth.currentUser;
    if (user != null) {
      final doctorId = user.uid;
      await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('bookings')
          .doc(appointmentToUpdate.id)
          .update({'status': 'Completed'});
    }
    updatedAppointments[event.index] = updatedAppointment;
    emit(state.copyWith(appointments: updatedAppointments, isLoading: false));
  }
}
