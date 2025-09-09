// import 'package:flutter/material.dart';
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
//       backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ProfileHeader(
//               onTap: () => NavigationService.navigateToProfileDetails(context),
//               viewModel: viewModel,
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ProfileOptionsList(
//                 onLogout: () => _handleLogout(context, viewModel),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const BottomNavigation(currentIndex: 2),
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
import 'package:vista_call_doctor/view_models/profile_view_model.dart';
import 'package:vista_call_doctor/views/profile/components/profile_header.dart';
import 'package:vista_call_doctor/views/profile/components/profile_options_list.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
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
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: _buildSettingsButton(context),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: _buildNotificationButton(context),
        ),
      ],
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
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
          // Add settings logic here if needed
        },
        icon: const Icon(
          Icons.settings_outlined,
          color: Color(0xFF6B7280),
          size: 22,
        ),
      ),
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

  Widget _buildBody(BuildContext context, DoctorProfileViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          ProfileHeader(
            onTap: () => NavigationService.navigateToProfileDetails(context),
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
            offset: const Offset(0, 4),
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
          Container(
            height: 40,
            width: 1,
            color: const Color(0xFFE5E7EB),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.star,
              title: 'Average\nRating',
              value: '4.8',
              color: const Color(0xFFFFB800),
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: const Color(0xFFE5E7EB),
          ),
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
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
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
      viewModel.logout();
      NavigationService.navigateToAuthWrapper(context);
    }
  }
}