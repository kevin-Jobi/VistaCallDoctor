

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_bloc.dart';
import 'package:vista_call_doctor/blocs/appointment/appointment_state.dart';
import 'package:vista_call_doctor/view_models/appointment_view_model.dart';
import 'package:vista_call_doctor/views/message/chat_detail_screen.dart';
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
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildTabBar(),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAppointmentsList('Upcoming'),
                    _buildAppointmentsList('Pending'),
                    _buildAppointmentsList('Completed'),
                    _buildAppointmentsList('Canceled'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final totalAppointments = state.appointments.length;
    final pendingCount = state.appointments
        .where((apt) => apt.status.toLowerCase() == 'pending')
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Schedule',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalAppointments total appointments',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB800),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$pendingCount Pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTabBar() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 4),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF5F7FA),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: TabBar(
  //       labelColor: Colors.white,
  //       unselectedLabelColor: const Color(0xFF6B7280),
  //       labelStyle: const TextStyle(
  //         fontSize: 13,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       unselectedLabelStyle: const TextStyle(
  //         fontSize: 13,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       indicator: BoxDecoration(
  //         gradient: const LinearGradient(
  //           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       indicatorPadding: const EdgeInsets.all(4),
  //       dividerColor: Colors.transparent,
  //       tabs: const [
  //         Tab(text: 'Upcoming'),
  //         Tab(text: 'Pending'),
  //         Tab(text: 'Completed'),
  //         Tab(text: 'Canceled'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        //  keep it false so all 4 tabs take equal width
        isScrollable: false,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,

        //  This fixes truncation:
        tabAlignment: TabAlignment.fill,
        labelPadding: EdgeInsets.zero,

        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Pending'),
          Tab(text: 'Completed'),
          Tab(text: 'Canceled'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(String status) {
    final filteredAppointments = state.appointments
        .where(
          (appointment) =>
              appointment.status.toLowerCase() == status.toLowerCase(),
        )
        .toList();

    print('Filtered appointments for $status: $filteredAppointments');

    if (filteredAppointments.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredAppointments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return AppointmentCard(
          appointment: appointment,
          onAccept: () => viewModel.acceptAppointment(
            state.appointments.indexOf(appointment),
          ),
          onCancel: () => viewModel.cancelAppointment(
            state.appointments.indexOf(appointment),
          ),
          onComplete: () => viewModel.completeAppointment(
            state.appointments.indexOf(appointment),
          ),
          onMessage: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                  patientId: appointment.patientName,
                  patientName: appointment.patientName ?? 'Unknown Patient',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    final statusConfig = _getEmptyStateConfig(status);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusConfig['icon'],
              size: 40,
              color: statusConfig['color'],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No ${status.toLowerCase()} appointments',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusConfig['message'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getEmptyStateConfig(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return {
          'icon': Icons.event_available,
          'color': const Color(0xFF10B981),
          'message': 'Your upcoming appointments\nwill appear here',
        };
      case 'pending':
        return {
          'icon': Icons.schedule,
          'color': const Color(0xFFFFB800),
          'message': 'New appointment requests\nwill appear here',
        };
      case 'completed':
        return {
          'icon': Icons.check_circle,
          'color': const Color(0xFF10B981),
          'message': 'Your completed appointments\nwill appear here',
        };
      case 'canceled':
        return {
          'icon': Icons.cancel,
          'color': const Color(0xFFEF4444),
          'message': 'Canceled appointments\nwill appear here',
        };
      default:
        return {
          'icon': Icons.event_note,
          'color': const Color(0xFF6B7280),
          'message': 'No appointments available',
        };
    }
  }
}
