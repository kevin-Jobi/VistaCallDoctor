// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/view_models/auth_wrapper.dart';
// import 'package:vista_call_doctor/views/profile.dart';
// import '../blocs/auth/auth_bloc.dart';
// import '../blocs/profile/profile_bloc.dart';
// import '../blocs/profile/profile_state.dart';
// import '../view_models/auth_view_model.dart';
// import '../navigation/bottom_navigation.dart';

// class DoctorProfileScreen extends StatelessWidget {
//   const DoctorProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authBloc = BlocProvider.of<AuthBloc>(context);
//     final authViewModel = AuthViewModel(authBloc);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocBuilder<ProfileBloc, ProfileState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(
//                     vertical: 6,
//                     horizontal: 12,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 196, 223, 241),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: ListTile(
//                     leading: const CircleAvatar(
//                       radius: 25,
//                       backgroundColor: Colors.grey,
//                       child: Icon(Icons.person, color: Colors.white),
//                     ),
//                     title: const Text('Dr. Najin'),
//                     subtitle: const Text('Cardiologist'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ProfileScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
                
//                 Expanded(
//                   child: ProfileOptionsList(
//                     onLogout: () async {
//                       final confirm = await showDialog<bool>(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Confirm Logout'),
//                           content: const Text(
//                             'Are you sure you want to log out?',
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, false),
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, true),
//                               child: const Text('Confirm'),
//                             ),
//                           ],
//                         ),
//                       );
//                       if (confirm == true) {
//                         authViewModel.logout();
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const AuthWrapper()),
//                             (route)=>false
                          
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: const BottomNavigation(currentIndex: 2),
//     );
//   }
// }

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
//           onTap: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Invite Friends feature coming soon!'),
//               ),
//             );
//           },
//         ),
//         ProfileOptionItem(
//           icon: Icons.feedback,
//           title: 'Feed Back',
//           onTap: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Feedback feature coming soon!')),
//             );
//           },
//         ),
//         ProfileOptionItem(
//           icon: Icons.lock,
//           title: 'Privacy And Policy',
//           onTap: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Privacy And Policy page coming soon!'),
//               ),
//             );
//           },
//         ),
//         ProfileOptionItem(
//           icon: Icons.description,
//           title: 'Terms And Conditions',
//           onTap: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Terms And Conditions page coming soon!'),
//               ),
//             );
//           },
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
// }

// class ProfileOptionItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final Color? textColor;
//   final VoidCallback onTap;

//   const ProfileOptionItem({
//     super.key,
//     required this.icon,
//     required this.title,
//     this.textColor,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: textColor ?? Colors.grey),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: textColor ?? Colors.black,
//           fontWeight: title == 'LogOut' ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//       trailing: const Icon(Icons.chevron_right, color: Colors.grey),
//       onTap: onTap,
//     );
//   }
// }
