// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
// import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
// import 'package:vista_call_doctor/blocs/availability/availability_event.dart';
// import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
// import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_bloc.dart';
// import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_event.dart';
// import 'package:vista_call_doctor/blocs/doctor_profile/doctor_profile_state.dart';
// import 'package:vista_call_doctor/view_models/availability_view_model.dart';
// import 'package:vista_call_doctor/view_models/doctor_profile_view_model.dart';
// import 'package:vista_call_doctor/views/availability/availability_ui.dart';
// import 'package:vista_call_doctor/views/profile/edit_field_screen.dart'; // Assume this file exists

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           DoctorProfileBloc(authBloc: context.read<AuthBloc>())..add(FetchProfile(null)),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8FAFE),
//         appBar: _buildAppBar(context),
//         body: _buildBody(context),
//       ),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       surfaceTintColor: Colors.transparent,
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF5F7FA),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
//         ),
//         child: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Color(0xFF6B7280),
//             size: 20,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       title: const Text(
//         'Doctor Profile',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w700,
//           color: Color(0xFF1A1A1A),
//         ),
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
//           child: _buildShareButton(context),
//         ),
//       ],
//     );
//   }

//   Widget _buildShareButton(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F7FA),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
//       ),
//       child: IconButton(
//         onPressed: () {
//           // Add share functionality
//         },
//         icon: const Icon(
//           Icons.share_outlined,
//           color: Color(0xFF6B7280),
//           size: 18,
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return _buildLoadingState();
//         }

//         if (state.errorMessage != null) {
//           return Center(child: Text(state.errorMessage!));
//         }

//         return FutureBuilder<Map<String, dynamic>>(
//           future: context
//               .read<DoctorProfileBloc>()
//               .viewModel
//               .getDoctorDetails(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return _buildLoadingState();
//             }

//             if (!snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text('No profile data available'));
//             }

//             final data = snapshot.data!;
//             final personal = data['personal'] ?? {};
//             final availability = data['availability'] ?? {};
//             final name = state.fullName ?? personal['fullName'] as String? ?? 'N/A';
//             final experience = state.experience ?? availability['yearsOfExperience'] as String? ?? 'N/A';
//             final phone = state.phone ?? personal['phone'] as String? ?? 'N/A';
//             final email = state.email ?? personal['email'] as String? ?? 'N/A';
//             final category = state.specialization ?? personal['specialization'] as String? ?? 'N/A';
//             final profileImageUrl =
//                 state.profileImageUrl ?? personal['profileImageUrl'] as String?;
//             final availableDays = List<String>.from(
//               availability['availableDays'] ?? [],
//             );
//             final availableTimeSlots = Map<String, List<String>>.from(
//               availability['availableTimeSlots'] ?? {},
//             );
//             final yearsOfExperience = availability['yearsOfExperience'] ?? '';
//             final fees = availability['fees'] ?? '';

//             final availabilityState = AvailabilityState(
//               availability: Availability(
//                 availableDays: availableDays,
//                 yearsOfExperience: yearsOfExperience,
//                 fees: fees,
//                 availableTimeSlots: availableTimeSlots,
//               ),
//             );

//             return _buildProfileContent(
//               context,
//               name,
//               experience,
//               phone,
//               email,
//               category,
//               profileImageUrl,
//               availableDays,
//               availableTimeSlots,
//               availabilityState,
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
//               strokeWidth: 3,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Loading profile...',
//               style: TextStyle(
//                 color: Color(0xFF6B7280),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileContent(
//     BuildContext context,
//     String name,
//     String experience,
//     String phone,
//     String email,
//     String category,
//     String? profileImageUrl,
//     List<String> availableDays,
//     Map<String, List<String>> availableTimeSlots,
//     AvailabilityState availabilityState,
//   ) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
//       child: Column(
//         children: [
//           _buildProfileHeader(context, name, category, profileImageUrl),
//           const SizedBox(height: 32),
//           _buildProfileDetails(
//             context,
//             name,
//             experience,
//             phone,
//             email,
//             category,
//           ),
//           const SizedBox(height: 24),
//           _buildAvailabilitySection(
//             context,
//             availableDays,
//             availableTimeSlots,
//             availabilityState,
//           ),
//           const SizedBox(height: 24),
//           _buildDocumentsSection(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader(
//     BuildContext context,
//     String name,
//     String category,
//     String? profileImageUrl,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF667EEA).withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.3),
//                 width: 3,
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: profileImageUrl != null
//                   ? Image.network(
//                       profileImageUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(
//                           Icons.person,
//                           size: 50,
//                           color: Colors.white,
//                         );
//                       },
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                       loadingProgress.expectedTotalBytes!
//                                 : null,
//                             color: Colors.white,
//                           ),
//                         );
//                       },
//                     )
//                   : const Icon(Icons.person, size: 50, color: Colors.white),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Dr. $name',
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//           _buildEditButton(context),
//         ],
//       ),
//     );
//   }

//   String _getInitials(String name) {
//     if (name.isEmpty) return '';

//     final nameParts = name.trim().split(' ');
//     if (nameParts.length >= 2) {
//       return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
//     } else if (nameParts.length == 1 && nameParts[0].isNotEmpty) {
//       return nameParts[0][0].toUpperCase();
//     }
//     return '';
//   }

//   Widget _buildEditButton(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 48,
//       child: TextButton.icon(
//         onPressed: () => context.read<DoctorProfileBloc>().add(
//           ProfileImageUpdateRequested(),
//         ),
//         icon: const Icon(Icons.edit_outlined, size: 18),
//         label: const Text(
//           'Edit',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         style: IconButton.styleFrom(foregroundColor: Colors.white),
//       ),
//     );
//   }

//   Widget _buildProfileDetails(
//     BuildContext context,
//     String name,
//     String experience,
//     String phone,
//     String email,
//     String category,
//   ) {
//     final bloc = context.read<DoctorProfileBloc>();

//     return Container(
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
//             child: Text(
//               'Personal Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//             ),
//           ),
//           _buildDetailItem(
//             context,
//             icon: Icons.person_outline,
//             label: 'Full Name',
//             value: name,
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EditFieldScreen(
//                   title: 'Full Name',
//                   initialValue: name,
//                   onSave: (newValue) =>
//                       bloc.add(ProfileNameUpdateRequested(newValue)),
//                 ),
//               ),
//             ),
//             showDivider: true,
//           ),
//           _buildDetailItem(
//             context,
//             icon: Icons.work_outline,
//             label: 'Experience',
//             value: experience,
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EditFieldScreen(
//                   title: 'Experience',
//                   initialValue: experience,
//                   onSave: (newValue) =>
//                       bloc.add(ProfileExperienceUpdateRequested(newValue)),
//                 ),
//               ),
//             ),
//             showDivider: true,
//           ),
//           _buildDetailItem(
//             context,
//             icon: Icons.phone_outlined,
//             label: 'Phone Number',
//             value: phone,
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EditFieldScreen(
//                   title: 'Phone Number',
//                   initialValue: phone,
//                   onSave: (newValue) =>
//                       bloc.add(ProfilePhoneUpdateRequested(newValue)),
//                 ),
//               ),
//             ),
//             showDivider: true,
//           ),
//           _buildDetailItem(
//             context,
//             icon: Icons.email_outlined,
//             label: 'Email Address',
//             value: email,
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EditFieldScreen(
//                   title: 'Email Address',
//                   initialValue: email,
//                   onSave: (newValue) =>
//                       bloc.add(ProfileEmailUpdateRequested(newValue)),
//                 ),
//               ),
//             ),
//             showDivider: true,
//           ),
//           _buildDetailItem(
//             context,
//             icon: Icons.medical_services_outlined,
//             label: 'Specialization',
//             value: category,
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EditFieldScreen(
//                   title: 'Specialization',
//                   initialValue: category,
//                   onSave: (newValue) =>
//                       bloc.add(ProfileSpecializationUpdateRequested(newValue)),
//                 ),
//               ),
//             ),
//             showDivider: false,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required String value,
//     required bool showDivider,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Row(
//               children: [
//                 Container(
//                   height: 44,
//                   width: 44,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: const Color(0xFF667EEA), size: 22),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         label,
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         value,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (onTap != null)
//                   Container(
//                     height: 32,
//                     width: 32,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF667EEA).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.edit,
//                       color: Color(0xFF667EEA),
//                       size: 16,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           if (showDivider)
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               height: 1,
//               color: const Color(0xFFF0F0F0),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentsSection(BuildContext context) {
//     return Container(
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
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   height: 44,
//                   width: 44,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.folder_outlined,
//                     color: Color(0xFF667EEA),
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Documents & Certificates',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Upload your professional documents',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: OutlinedButton.icon(
//                 onPressed: () {
//                   // Add document upload functionality
//                 },
//                 icon: const Icon(Icons.add, size: 18),
//                 label: const Text(
//                   'Add Documents',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: const Color(0xFF667EEA),
//                   side: const BorderSide(color: Color(0xFF667EEA), width: 1.5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAvailabilitySection(
//     BuildContext context,
//     List<String> availableDays,
//     Map<String, List<String>> availableTimeSlots,
//     AvailabilityState availabilityState,
//   ) {
//     final doctorProfileBloc = context.read<DoctorProfileBloc>();
//     final authBloc = context.read<AuthBloc>();
//     final user = _getCurrentUser(authBloc.state);
//     if (user == null) return const SizedBox.shrink();

//     final doctorId = user.uid;
//     final availabilityBloc = AvailabilityBloc();

//     doctorProfileBloc.viewModel.getDoctorDetails().then((data) {
//       final availability = data['availability'] ?? {};
//       final initialDays = (availability['availableDays'] as List?)?.where((day) => day.isNotEmpty).toList() ?? [];
//       final initialSlots = Map<String, List<String>>.from(
//         availability['availableTimeSlots'] ?? {},
//       );
//       final initialYears = availability['yearsOfExperience'] ?? '';
//       final initialFees = availability['fees'] ?? '';

//       availabilityBloc.add(ResetAvailability());
//       availabilityBloc.add(UpdateYearsOfExperience(initialYears));
//       availabilityBloc.add(UpdateFees(initialFees));
//       for (var day in initialDays) {
//         availabilityBloc.add(ToggleDay(day));
//         if (initialSlots[day] != null) {
//           availabilityBloc.add(UpdateDaySlots(day, initialSlots[day]!));
//         }
//       }
//     });

//     return Container(
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Availability',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.edit,
//                     color: Color(0xFF667EEA),
//                     size: 20,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BlocProvider.value(
//                           value: availabilityBloc,
//                           child: AvailabilityUI(
//                             formKey: GlobalKey<FormState>(),
//                             viewModel: AvailabilityViewModel(availabilityBloc),
//                             state: availabilityState,
//                             isFromProfile: true,
//                           ),
//                         ),
//                       ),
//                     ).then((_) {
//                       doctorProfileBloc.add(FetchProfile(doctorId));
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           ...availableDays.where((day) => day.isNotEmpty).map((day) {
//             final timeSlots = availableTimeSlots[day] ?? [];
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 44,
//                     width: 44,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF5F7FA),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.calendar_today,
//                       color: Color(0xFF667EEA),
//                       size: 22,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _getFullDayName(day),
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF1A1A1A),
//                           ),
//                         ),
//                         if (timeSlots.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 4),
//                             child: Wrap(
//                               spacing: 8,
//                               runSpacing: 4,
//                               children: timeSlots
//                                   .map((slot) => _buildTimeSlotChip(slot))
//                                   .toList(),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   UserModel? _getCurrentUser(AuthState state) {
//     if (state is Authenticated) {
//       return state.user;
//     }
//     final firebaseUser = FirebaseAuth.instance.currentUser;
//     return firebaseUser != null ? UserModel.fromFirebaseUser(firebaseUser) : null;
//   }

//   Widget _buildTimeSlotChip(String timeSlot) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: const Color(0xFF667EEA).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: const Color(0xFF667EEA).withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Text(
//         timeSlot,
//         style: const TextStyle(
//           color: Color(0xFF667EEA),
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   String _getFullDayName(String shortDay) {
//     const Map<String, String> dayNames = {
//       'Mon': 'Monday',
//       'Tue': 'Tuesday',
//       'Wed': 'Wednesday',
//       'Thu': 'Thursday',
//       'Fri': 'Friday',
//       'Sat': 'Saturday',
//       'Sun': 'Sunday',
//     };
//     return dayNames[shortDay] ?? shortDay;
//   }
// }