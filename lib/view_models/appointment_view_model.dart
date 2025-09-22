// import 'package:flutter/material.dart';
// import 'package:vista_call_doctor/views/profile/doctor_profile_screen.dart';

// import '../blocs/appointment/appointment_bloc.dart';
// import '../blocs/appointment/appointment_event.dart';

// class AppointmentViewModel {
//   final AppointmentBloc appointmentBloc;

//   AppointmentViewModel(this.appointmentBloc);

//   void loadAppointments() {
//     appointmentBloc.add(const LoadAppointments());
//   }

//   void acceptAppointment(int index) {
//     appointmentBloc.add(AcceptAppointment(index));
//   }

//   void cancelAppointment(int index) {
//     appointmentBloc.add(CancelAppointment(index));
//   }

//   void completeAppointment(int index) {
//     appointmentBloc.add(CompleteAppointment(index));
//   }

//   void navigateToProfile(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const DoctorProfileScreen()),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:vista_call_doctor/views/profile/doctor_profile_screen.dart';

import '../blocs/appointment/appointment_bloc.dart';
import '../blocs/appointment/appointment_event.dart';

class AppointmentViewModel {
  final AppointmentBloc appointmentBloc;

  AppointmentViewModel(this.appointmentBloc);

  void loadAppointments() {
    appointmentBloc.add(const LoadAppointments());
  }

  void completeAppointment(int index) {
    appointmentBloc.add(CompleteAppointment(index));
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DoctorProfileScreen()),
    );
  }
}