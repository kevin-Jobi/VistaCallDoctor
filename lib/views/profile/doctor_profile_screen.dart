// views/profile/doctor_profile_screen.dart
import 'package:flutter/material.dart';
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
    final viewModel = DoctorProfileViewModel(authBloc );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 247, 255),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 237, 247, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileHeader(
              onTap: () => NavigationService.navigateToProfileDetails(context),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ProfileOptionsList(
                onLogout: () => _handleLogout(context, viewModel),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
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