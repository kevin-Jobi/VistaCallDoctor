// // views/profile/components/profile_header.dart
// import 'package:flutter/material.dart';
// import 'package:vista_call_doctor/view_models/profile_view_model.dart';

// class ProfileHeader extends StatelessWidget {
//   final VoidCallback onTap;
//   final DoctorProfileViewModel viewModel;

//   const ProfileHeader({super.key, required this.onTap, required this.viewModel});

//   @override
//   Widget build(BuildContext context) {
// return FutureBuilder<Map<String, dynamic>>(
//       future: viewModel.getDoctorDetails(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final doctorName = snapshot.data?['name'] ?? 'Unknown';
//         final specialization = snapshot.data?['specialization'] ?? 'N/A';
//         return Container(
//           margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 196, 223, 241),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: ListTile(
//             leading: const CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, color: Colors.white),
//             ),
//             title: Text('Dr. $doctorName'),
//             subtitle: Text(specialization),
//             onTap: onTap,
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:vista_call_doctor/view_models/profile_view_model.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onTap;
  final DoctorProfileViewModel viewModel;

  const ProfileHeader({super.key, required this.onTap, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: viewModel.getDoctorDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final doctorName = snapshot.data?['name'] ?? 'Unknown';
        final specialization = snapshot.data?['specialization'] ?? 'N/A';
        final email = snapshot.data?['email'] ?? '';

        return _buildProfileCard(context, doctorName, specialization, email);
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    String doctorName,
    String specialization,
    String email,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              color: const Color(0xFF667EEA).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildProfileAvatar(doctorName),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProfileInfo(doctorName, specialization, email),
            ),
            _buildEditIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String doctorName) {
    final initials = _getInitials(doctorName);
    
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: initials.isNotEmpty
          ? Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : const Icon(
              Icons.person,
              color: Colors.white,
              size: 32,
            ),
    );
  }

  String _getInitials(String name) {
    if (name == 'Unknown' || name.isEmpty) return '';
    
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1 && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }

  Widget _buildProfileInfo(String doctorName, String specialization, String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dr. $doctorName',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            specialization,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEditIcon() {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.edit_outlined,
        color: Colors.white.withOpacity(0.9),
        size: 18,
      ),
    );
  }
}