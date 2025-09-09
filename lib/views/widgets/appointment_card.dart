// import 'package:flutter/material.dart';
// import 'package:vista_call_doctor/models/appointment_model.dart';

// class AppointmentCard extends StatelessWidget {
//   final AppointmentModel appointment;
//   final VoidCallback onAccept;
//   final VoidCallback onCancel;
//   final VoidCallback onComplete;

//   const AppointmentCard({
//     super.key,
//     required this.appointment,
//     required this.onAccept,
//     required this.onCancel,
//     required this.onComplete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             _buildPatientAvatar(),
//             const SizedBox(width: 10),
//             _buildPatientInfo(),
//             _buildActionButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPatientAvatar() {
//     return const CircleAvatar(
//       radius: 30,
//       backgroundColor: Colors.grey,
//       child: Icon(Icons.person, color: Colors.white),
//     );
//   }

//   Widget _buildPatientInfo() {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             appointment.patientName,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           Text('${appointment.slot} '),
//           Text('Option: ${appointment.type}'),
//           Text('Date: ${appointment.date}'),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Column(
//       children: [
//         if (appointment.status == 'Pending') ...[
//           ElevatedButton(
//             onPressed: onAccept,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color.fromARGB(255, 106, 204, 109),
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Accept'),
//           ),
//           ElevatedButton(
//             onPressed: onCancel,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color.fromARGB(255, 232, 72, 61),
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Cancel'),
//           ),
//         ],
//         if (appointment.status == 'Upcoming') ...[
//           ElevatedButton(
//             onPressed: onComplete,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color.fromARGB(255, 0, 191, 255),
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Completed'),
//           ),
//         ],
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:vista_call_doctor/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onAccept;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onAccept,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                _buildPatientAvatar(),
                const SizedBox(width: 16),
                Expanded(child: _buildPatientInfo()),
                _buildStatusBadge(),
              ],
            ),
            if (_shouldShowActionButtons()) ...[
              const SizedBox(height: 16),
              const Divider(
                color: Color(0xFFF0F0F0),
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPatientAvatar() {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        gradient: _getAvatarGradient(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  LinearGradient _getAvatarGradient() {
    switch (appointment.status.toLowerCase()) {
      case 'pending':
        return const LinearGradient(
          colors: [Color(0xFFFFB800), Color(0xFFFF8A00)],
        );
      case 'upcoming':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        );
      case 'completed':
        return const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        );
      case 'canceled':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF4B5563)],
        );
    }
  }

  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.patientName,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              appointment.slot,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.video_call,
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              appointment.type,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              appointment.date,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final color = _getStatusColor();
    final bgColor = color.withOpacity(0.1);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        appointment.status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (appointment.status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFB800);
      case 'upcoming':
        return const Color(0xFF10B981);
      case 'completed':
        return const Color(0xFF6366F1);
      case 'canceled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  bool _shouldShowActionButtons() {
    return appointment.status == 'Pending' || appointment.status == 'Upcoming';
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (appointment.status == 'Pending') ...[
          Expanded(
            child: _buildButton(
              label: 'Decline',
              onPressed: onCancel,
              isPrimary: false,
              icon: Icons.close,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildButton(
              label: 'Accept',
              onPressed: onAccept,
              isPrimary: true,
              icon: Icons.check,
            ),
          ),
        ],
        if (appointment.status == 'Upcoming') ...[
          Expanded(
            child: _buildButton(
              label: 'Mark Complete',
              onPressed: onComplete,
              isPrimary: true,
              icon: Icons.check_circle,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
    required IconData icon,
  }) {
    return Container(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 16,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary 
              ? const Color(0xFF667EEA)
              : Colors.white,
          foregroundColor: isPrimary 
              ? Colors.white
              : const Color(0xFF6B7280),
          elevation: 0,
          shadowColor: Colors.transparent,
          side: isPrimary 
              ? null 
              : const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}