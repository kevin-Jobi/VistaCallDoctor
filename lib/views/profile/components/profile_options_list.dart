// views/profile/components/profile_options_list.dart
import 'package:flutter/material.dart';
import 'profile_option_item.dart';

class ProfileOptionsList extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileOptionsList({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfileOptionItem(
          icon: Icons.group,
          title: 'Invite Friends',
          onTap: () => _showComingSoonSnackbar(context, 'Invite Friends'),
        ),
        ProfileOptionItem(
          icon: Icons.feedback,
          title: 'Feed Back',
          onTap: () => _showComingSoonSnackbar(context, 'Feedback'),
        ),
        ProfileOptionItem(
          icon: Icons.lock,
          title: 'Privacy And Policy',
          onTap: () => _showComingSoonSnackbar(context, 'Privacy And Policy'),
        ),
        ProfileOptionItem(
          icon: Icons.description,
          title: 'Terms And Conditions',
          onTap: () => _showComingSoonSnackbar(context, 'Terms And Conditions'),
        ),
        ProfileOptionItem(
          icon: Icons.logout,
          title: 'LogOut',
          textColor: Colors.red,
          onTap: onLogout,
        ),
      ],
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature coming soon!')),
    );
  }
}