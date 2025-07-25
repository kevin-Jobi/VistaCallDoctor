// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
// import 'package:vista_call_doctor/view_models/auth_view_model.dart';
// import 'package:vista_call_doctor/views/doctor_login_screen.dart';
// import 'profile_filling.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authBloc = BlocProvider.of<AuthBloc>(context);
//     final viewModel = AuthViewModel(authBloc);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 41, 156, 249),
//       appBar: AppBar(
//         title: const Text(
//           'Hey Doctor ',
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             // fontStyle: FontStyle.italic,
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 41, 156, 249),
//       ),
// body: SizedBox.expand(
//   child: Container(
//     decoration: const BoxDecoration(
//       color: Colors.white, // Body background color
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(40),
//         topRight: Radius.circular(40),
//       ),
//     ),
//     // margin: const EdgeInsets.only(top: 30), // Create space below the AppBar
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, state) {
//           if (state is AuthLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is AuthFailure) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Error: ${state.error}'),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () => viewModel.signInWithGoogle(),
//                     icon: const Icon(Icons.g_mobiledata),
//                     label: const Text('Sign in with Google'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Image.asset(
//                   'assets/images/Rectangle 69.png',
//                   height: 220,
//                   width: double.infinity,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Welcome to \n VistaDoctor',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 29,
//                     color: Color.fromARGB(255, 7, 47, 146),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 const Text(
//                   'Join our trusted network.\nRegister your profile, manage appointments,\nand connect with patients.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DoctorLoginScreen(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.login),
//                   label: const Text(
//                     'Login to Account',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 16, 22, 121),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 15,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ProfileFillingScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Create Account',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 16, 22, 121),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 15,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         },
//       ),
//     ),
//   ),
// ),

//     );
//   }
// }

// views/welcome/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/view_models/auth_view_model.dart';
import 'package:vista_call_doctor/views/welcome/welcome_screen_ui.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final viewModel = AuthViewModel(authBloc);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 156, 249),
      appBar: AppBar(
        title: const Text(
          'Hey Doctor',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 156, 249),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return WelcomeScreenUi(state: state, viewModel: viewModel);
        },
      ),
    );
  }
}
