// import 'package:flutter/material.dart';
// import 'package:vista_call_doctor/views/appointment/appointment_screen.dart';
// import 'package:vista_call_doctor/views/message/message_screen.dart';
// import 'package:vista_call_doctor/views/profile/doctor_profile_screen.dart';

// class BottomNavigation extends StatelessWidget {
//   final int currentIndex;

//   const BottomNavigation({super.key, required this.currentIndex});

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) {
//         if (index == currentIndex) return;
//         Widget targetScreen;
//         switch (index) {
//           case 0:
//             targetScreen = const AppointmentScreen();
//             break;
//           case 1:
//             targetScreen = const MessageScreen();
//             break;
//           case 2:
//             targetScreen = const DoctorProfileScreen();
//             break;
//           default:
//             targetScreen = const AppointmentScreen();
//         }
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => targetScreen),
//         );
//       },
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.calendar_today),
//           label: 'Appointment',
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:vista_call_doctor/views/appointment/appointment_screen.dart';
import 'package:vista_call_doctor/views/message/message_screen.dart';
import 'package:vista_call_doctor/views/profile/doctor_profile_screen.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Appointments',
                screen: const AppointmentScreen(),
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: 'Messages',
                screen: const MessageScreen(),
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                screen: const DoctorProfileScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Widget screen,
  }) {
    final isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (index == currentIndex) return;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => screen,
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? Colors.white : const Color(0xFF6B7280),
                size: 22,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}