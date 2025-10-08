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
import 'package:share_plus/share_plus.dart';
import 'package:vista_call_doctor/views/profile/components/privacy_policy.dart';
import 'profile_option_item.dart';
import 'package:url_launcher/url_launcher.dart';


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
                onTap: () => _shareAppInvitation(context),
              ),
              ProfileOptionItem(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                subtitle: 'Help us improve',
                // color: Colors.orange.shade600,
                // onTap:
                //  () async {
                //   final Uri emailUri = Uri(
                //     scheme: 'mailto',
                //     path: 'kevinemmanu@gmail.com', // ← Replace with your email
                //     queryParameters: {
                //       'subject': 'Feedback for VistaCall App',
                //     },
                //   );

                //   if (await canLaunchUrl(emailUri)) {
                //     await launchUrl(emailUri);
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('Could not open email app.'),
                //       ),
                //     );
                //   }
                // },
                onTap: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'kevinemmanu@gmail.com',
                    queryParameters: {'subject': 'Feedback for VistaCall App'},
                  );

                  try {
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(
                        emailUri,
                        mode: LaunchMode
                            .externalApplication, // ⬅️ Forces open email app
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No email app found. Please install an email client.',
                          ),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                    }
                  } catch (e) {
                    print('Email launch error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not open email app.'),
                        backgroundColor: Color(0xFFEF4444),
                      ),
                    );
                  }
                },
              ),
              ProfileOptionItem(
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy terms',
                showBorder: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                )),
              ),
              // ProfileOptionItem(
              //   icon: Icons.description_outlined,
              //   title: 'Terms & Conditions',
              //   subtitle: 'View terms of service',
              //   showBorder: false,
              //   onTap: () =>
              //       _showComingSoonSnackbar(context, 'Terms & Conditions'),
              // ),
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

  void _shareAppInvitation(BuildContext context) async {
    const String appLink =
        'https://your-app-link.com'; // Replace with your app's download link
    const String invitationMessage =
        'Hey! Check out this amazing app! Download it here: $appLink';
    try {
      final result = await SharePlus.instance.share(
        ShareParams(text: invitationMessage),
      );
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invitation shared successfully!'),
            backgroundColor: Color(0xFF667EEA),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Sharing error: $e'); // Add logging to diagnose the issue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to share invitation. Please try again.'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
