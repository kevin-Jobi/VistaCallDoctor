// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/navigation/bottom_navigation.dart';
// import 'package:vista_call_doctor/services/dialog_service.dart';
// import 'package:vista_call_doctor/services/navigation_service.dart';
// import 'package:vista_call_doctor/view_models/profile_view_model.dart';
// import 'package:vista_call_doctor/views/profile/components/profile_header.dart';
// import 'package:vista_call_doctor/views/profile/components/profile_options_list.dart';

// class DoctorProfileScreen extends StatelessWidget {
//   const DoctorProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authBloc = BlocProvider.of<AuthBloc>(context);
//     final viewModel = DoctorProfileViewModel(authBloc);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFE),
//       appBar: _buildAppBar(context),
//       body: _buildBody(context, viewModel),
//       bottomNavigationBar: const BottomNavigation(currentIndex: 2),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: Colors.white,
//       elevation: 0,
//       surfaceTintColor: Colors.transparent,
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       title: const Text(
//         'Profile',
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.w700,
//           color: Color(0xFF1A1A1A),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(BuildContext context, DoctorProfileViewModel viewModel) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
//       child: Column(
//         children: [
//           ProfileHeader(
//             onTap: () => NavigationService.navigateToProfileDetails(context),
//             viewModel: viewModel,
//           ),
//           const SizedBox(height: 32),
//           _buildQuickStats(),
//           const SizedBox(height: 24),
//           ProfileOptionsList(onLogout: () => _handleLogout(context, viewModel)),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildStatItem(
//               icon: Icons.event_available,
//               title: 'Total\nAppointments',
//               value: '156',
//               color: const Color(0xFF10B981),
//             ),
//           ),
//           Container(height: 40, width: 1, color: const Color(0xFFE5E7EB)),
//           Expanded(
//             child: _buildStatItem(
//               icon: Icons.star,
//               title: 'Average\nRating',
//               value: '4.8',
//               color: const Color(0xFFFFB800),
//             ),
//           ),
//           Container(height: 40, width: 1, color: const Color(0xFFE5E7EB)),
//           Expanded(
//             child: _buildStatItem(
//               icon: Icons.people,
//               title: 'Total\nPatients',
//               value: '89',
//               color: const Color(0xFF667EEA),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Container(
//           height: 48,
//           width: 48,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: color, size: 24),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1A1A),
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[600],
//             height: 1.2,
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _handleLogout(
//     BuildContext context,
//     DoctorProfileViewModel viewModel,
//   ) async {
//     final confirm = await DialogService.showLogoutConfirmation(context);
//     if (confirm == true) {
//       viewModel.logout();
//       NavigationService.navigateToAuthWrapper(context);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/navigation/bottom_navigation.dart';
import 'package:vista_call_doctor/services/dialog_service.dart';
import 'package:vista_call_doctor/services/navigation_service.dart';
import 'package:vista_call_doctor/view_models/doctor_profile_view_model.dart';
import 'package:vista_call_doctor/views/profile/components/profile_header.dart';
import 'package:vista_call_doctor/views/profile/components/profile_options_list.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context
        .read<AuthBloc>(); // Use context.read instead of BlocProvider.of
    final viewModel = DoctorProfileViewModel(authBloc);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: _buildAppBar(context),
      body: _buildBody(context, viewModel),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DoctorProfileViewModel viewModel) {
    return FutureBuilder<Map<String, dynamic>>(
      future: viewModel.getDoctorDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final data = snapshot.data ?? {};
        final personal = data['personal'] ?? {};
        // final availability = data['availability'] ?? {};
        final name = personal['fullName'] ?? 'Unknown';
        final email = personal['email'] ?? '';
        final category = personal['department'] ?? 'N/A';
        final profileImageUrl = personal['profileImageUrl'] as String?;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              ProfileHeader(
                name: name,
                category: category,
                email: email,
                profileImageUrl: profileImageUrl,
                onTap: () =>
                    NavigationService.navigateToProfileDetails(context),
                viewModel: viewModel,
              ),
              const SizedBox(height: 32),
              _buildQuickStats(),
              const SizedBox(height: 24),
              ProfileOptionsList(
                onLogout: () => _handleLogout(context, viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
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
              'Loading profile...',
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

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.event_available,
              title: 'Total\nAppointments',
              value: '156',
              color: const Color(0xFF10B981),
            ),
          ),
          Container(height: 40, width: 1, color: const Color(0xFFE5E7EB)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.star,
              title: 'Average\nRating',
              value: '4.8',
              color: const Color(0xFFFFB800),
            ),
          ),
          Container(height: 40, width: 1, color: const Color(0xFFE5E7EB)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.people,
              title: 'Total\nPatients',
              value: '89',
              color: const Color(0xFF667EEA),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    DoctorProfileViewModel viewModel,
  ) async {
    final confirm = await DialogService.showLogoutConfirmation(context);
    if (confirm == true) {
      viewModel.logout(); // Now defined in DoctorProfileViewModel
      NavigationService.navigateToAuthWrapper(context);
    }
  }
}
