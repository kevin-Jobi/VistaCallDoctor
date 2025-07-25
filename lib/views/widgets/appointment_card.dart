// views/widgets/appointment_card.dart
import 'package:flutter/material.dart';
import 'package:vista_call_doctor/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildPatientAvatar(),
            const SizedBox(width: 10),
            _buildPatientInfo(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientAvatar() {
    return const CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildPatientInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.patientName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('${appointment.age} | ${appointment.issue}'),
          Text('Option: ${appointment.type}'),
          Text('Date: ${appointment.date}'),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onAccept,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 106, 204, 109),
            foregroundColor: Colors.white,
          ),
          child: const Text('Accept'),
        ),
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 232, 72, 61),
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}