// views/appointment/appointment_ui.dart
import 'package:flutter/material.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_state.dart';
import 'package:vista_call_doctor/view_models/appointment_view_model.dart';
import 'package:vista_call_doctor/views/widgets/appointment_card.dart';

class AppointmentUI extends StatelessWidget {
  final AppointmentViewModel viewModel;
  final AppointmentState state;

  const AppointmentUI({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        _buildAppointmentsList(context),
      ],
    );
  }

  Widget _buildTabBar() {
    return const DefaultTabController(
      length: 3,
      child: TabBar(
        tabs: [
          Tab(text: 'Upcoming'),
          Tab(text: 'Completed'),
          Tab(text: 'Canceled'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.appointments.length,
        itemBuilder: (context, index) {
          final appointment = state.appointments[index];
          if (appointment.status != 'Upcoming') {
            return const SizedBox.shrink();
          }
          return AppointmentCard(
            appointment: appointment,
            onAccept: () => viewModel.acceptAppointment(index),
            onCancel: () => viewModel.cancelAppointment(index),
          );
        },
      ),
    );
  }
}