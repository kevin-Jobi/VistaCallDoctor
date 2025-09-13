import 'package:flutter/material.dart';
import 'package:vista_call_doctor/view_models/doctor_profile_view_model.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String category;
  final String? profileImageUrl;
  final String email;
  final VoidCallback onTap;
  final DoctorProfileViewModel viewModel;

  const ProfileHeader({
    super.key,
    this.name = 'Unknown', // Default value
    this.category = 'N/A', // Default value
    this.profileImageUrl, // Optional
    required this.email,
    required this.onTap,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<Map<String, dynamic>>(
    //   future: viewModel.getDoctorDetails(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return _buildLoadingState();
    //     }

    //     final doctorName = snapshot.data?['name'] ?? 'Unknown';
    //     final specialization = snapshot.data?['specialization'] ?? 'N/A';
    //     final email = snapshot.data?['email'] ?? '';

    return _buildProfileCard(context, name, category, email);
    //   },
    // );
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
            _buildProfileAvatar(doctorName, profileImageUrl),
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

  Widget _buildProfileAvatar(String doctorName, String? profileImageUrl) {
    final initials = _getInitials(doctorName);

    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: profileImageUrl != null
            ? Image.network(
                profileImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return initials.isNotEmpty
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
                      : const Icon(Icons.person, color: Colors.white, size: 32);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                }, // },
              )
            : (initials.isNotEmpty
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
                  : const Icon(Icons.person, color: Colors.white, size: 32)),
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

  Widget _buildProfileInfo(
    String doctorName,
    String specialization,
    String email,
  ) {
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
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Icon(
        Icons.edit_outlined,
        color: Colors.white.withOpacity(0.9),
        size: 18,
      ),
    );
  }
}
