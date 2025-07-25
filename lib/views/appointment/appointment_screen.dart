// views/appointment/appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_bloc.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_state.dart';
import 'package:vista_call_doctor/navigation/bottom_navigation.dart';
import 'package:vista_call_doctor/view_models/appointment_view_model.dart';
import 'package:vista_call_doctor/views/doctor_profile_screen.dart';
import 'appointment_ui.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = BlocProvider.of<AppointmentBloc>(context);
    final viewModel = AppointmentViewModel(appointmentBloc);

    viewModel.loadAppointments();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 247, 255),
        appBar: _buildAppBar(context, viewModel),
        body: _buildBody(viewModel),
        bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AppointmentViewModel viewModel) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 223, 241, 255),
      title: const Text('Hey, Fariz'),
      actions: [
        _buildProfileAvatar(context, viewModel),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildProfileAvatar(BuildContext context, AppointmentViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.navigateToProfile(context),
      child: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(AppointmentViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return AppointmentUI(
            viewModel: viewModel,
            state: state,
          );
        },
      ),
    );
  }
}