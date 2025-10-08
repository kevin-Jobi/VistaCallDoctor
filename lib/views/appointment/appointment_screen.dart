// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/appointment/appointment_bloc.dart';
// import 'package:vista_call_doctor/blocs/appointment/appointment_event.dart';
// import 'package:vista_call_doctor/blocs/appointment/appointment_state.dart';
// import 'package:vista_call_doctor/navigation/bottom_navigation.dart';
// import 'package:vista_call_doctor/view_models/appointment_view_model.dart';
// import 'appointment_ui.dart';

// class AppointmentScreen extends StatelessWidget {
//   const AppointmentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final appointmentBloc = BlocProvider.of<AppointmentBloc>(context);
//     final viewModel = AppointmentViewModel(appointmentBloc);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       appointmentBloc.add(const LoadAppointments());
//     });

//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//         appBar: _buildAppBar(context),
//         body: _buildBody(viewModel),
//         bottomNavigationBar: const BottomNavigation(currentIndex: 0),
//       ),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     String doctorName = 'doctor';
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doctorId = user.uid;
//       final doctorDoc = FirebaseFirestore.instance
//           .collection('doctors')
//           .doc(doctorId)
//           .get();
//       doctorDoc
//           .then((doc) {
//             if (doc.exists && doc.data() != null) {
//               final data = doc.data()!;
//               doctorName = data['name'] ?? 'Doctor';
//             }
//           })
//           .catchError((e) {
//             print('Error fecting doctor name $e');
//           });
//     }
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: const Color.fromARGB(255, 223, 241, 255),
//       title: Text('Hey, $doctorName'),
//       actions: [_buildProfileAvatar(context), const SizedBox(width: 10)],
//     );
//   }

//   Widget _buildProfileAvatar(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pushNamed(context, '/doctor_profile'),
//       child: const CircleAvatar(
//         radius: 20,
//         backgroundColor: Colors.grey,
//         child: Icon(Icons.person, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildBody(AppointmentViewModel viewModel) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: BlocBuilder<AppointmentBloc, AppointmentState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return AppointmentUI(viewModel: viewModel, state: state);
//         },
//       ),
//     );
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_bloc.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_event.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_state.dart';
import 'package:vista_call_doctor/navigation/bottom_navigation.dart';
import 'package:vista_call_doctor/view_models/appointment_view_model.dart';
import 'package:vista_call_doctor/views/profile/doctor_profile_screen.dart';
import 'appointment_ui.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = BlocProvider.of<AppointmentBloc>(context);
    final viewModel = AppointmentViewModel(appointmentBloc);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appointmentBloc.add(const LoadAppointments());
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFE),
        appBar: _buildAppBar(context),
        body: _buildBody(viewModel),
        bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    String doctorName = 'Doctor';
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doctorId = user.uid;
      final doctorDoc = FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      doctorDoc
          .then((doc) {
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          doctorName = data['name'] ?? 'Doctor';
        }
      })
          .catchError((e) {
        print('Error fetching doctor name $e');
      });
    }

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning,',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Dr. $doctorName',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
      actions: [
        // Container(
        //   margin: const EdgeInsets.only(right: 8),
        //   child: _buildNotificationButton(context),
        // ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: _buildProfileAvatar(context),
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
      ),
      child: IconButton(
        onPressed: () {
          // Add notification logic here if needed
        },
        icon: const Icon(
          Icons.notifications_outlined,
          color: Color(0xFF6B7280),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorProfileScreen())),
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildBody(AppointmentViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading appointments...',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return AppointmentUI(viewModel: viewModel, state: state);
        },
      ),
    );
  }
}