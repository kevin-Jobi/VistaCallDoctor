// // views/profile/components/profile_options_list.dart
// import 'package:flutter/material.dart';
// import 'profile_option_item.dart';

// class ProfileOptionsList extends StatelessWidget {
//   final VoidCallback onLogout;

//   const ProfileOptionsList({super.key, required this.onLogout});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         ProfileOptionItem(
//           icon: Icons.group,
//           title: 'Invite Friends',
//           onTap: () => _showComingSoonSnackbar(context, 'Invite Friends'),
//         ),
//         ProfileOptionItem(
//           icon: Icons.feedback,
//           title: 'Feed Back',
//           onTap: () => _showComingSoonSnackbar(context, 'Feedback'),
//         ),
//         ProfileOptionItem(
//           icon: Icons.lock,
//           title: 'Privacy And Policy',
//           onTap: () => _showComingSoonSnackbar(context, 'Privacy And Policy'),
//         ),
//         ProfileOptionItem(
//           icon: Icons.description,
//           title: 'Terms And Conditions',
//           onTap: () => _showComingSoonSnackbar(context, 'Terms And Conditions'),
//         ),
//         ProfileOptionItem(
//           icon: Icons.logout,
//           title: 'LogOut',
//           textColor: Colors.red,
//           onTap: onLogout,
//         ),
//       ],
//     );
//   }

//   void _showComingSoonSnackbar(BuildContext context, String feature) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('$feature feature coming soon!')),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'profile_option_item.dart';

class ProfileOptionsList extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileOptionsList({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings & Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileOptionItem(
                icon: Icons.group_outlined,
                title: 'Invite Friends',
                subtitle: 'Share the app with colleagues',
                showBorder: true,
                onTap: () => _showComingSoonSnackbar(context, 'Invite Friends'),
              ),
              ProfileOptionItem(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                subtitle: 'Help us improve the app',
                showBorder: true,
                onTap: () => _showComingSoonSnackbar(context, 'Feedback'),
              ),
              ProfileOptionItem(
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy terms',
                showBorder: true,
                onTap: () => _showComingSoonSnackbar(context, 'Privacy Policy'),
              ),
              ProfileOptionItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'View terms of service',
                showBorder: false,
                onTap: () => _showComingSoonSnackbar(context, 'Terms & Conditions'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ProfileOptionItem(
            icon: Icons.logout_outlined,
            title: 'Sign Out',
            subtitle: 'Sign out from your account',
            textColor: const Color(0xFFEF4444),
            iconColor: const Color(0xFFEF4444),
            showBorder: false,
            onTap: onLogout,
          ),
        ),
      ],
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$feature feature coming soon!',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF667EEA),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}