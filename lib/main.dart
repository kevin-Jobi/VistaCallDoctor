// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/config.dart';
// import 'package:vista_call_doctor/firebase_options.dart';
// import 'package:vista_call_doctor/services/auth_service.dart';
// import 'blocs/profile/profile_bloc.dart';
// import 'blocs/availability/availability_bloc.dart';
// import 'blocs/certificate/certificate_bloc.dart';
// import 'blocs/appointment/appointment_bloc.dart';
// import 'blocs/message/message_bloc.dart';
// import 'views/splash_screen.dart';

// main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => AuthBloc(AuthService())),
//         BlocProvider(create: (context) => ProfileBloc()),
//         BlocProvider(create: (context) => AvailabilityBloc()),
//         // BlocProvider(create: (context) => CertificateBloc()),
//         BlocProvider(create: (context) => AppointmentBloc()),
//         BlocProvider(create: (context) => MessageBloc()),
//         BlocProvider(
//           create: (context) =>
//               CertificateBloc(cloudinary, FirebaseFirestore.instance),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'VistaCall',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }
//*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-**-*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vista_call_doctor/blocs/ImagePicker/image_picker_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_bloc.dart';
import 'package:vista_call_doctor/config.dart';
import 'package:vista_call_doctor/firebase_options.dart';
import 'package:vista_call_doctor/services/auth_service.dart';
import 'package:vista_call_doctor/services/cloudinary_service.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/availability/availability_bloc.dart';
import 'blocs/certificate/certificate_bloc.dart';
import 'blocs/appointment/appointment_bloc.dart';
import 'blocs/message/message_bloc.dart';
import 'views/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final cloudinary = Cloudinary(cloudName:'dc6nq0pb1',apiKey:'392385925718134',apiSecret:'pMtNbKN4WwLbtsJnc0Yzvqgf75k');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthService())),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => AvailabilityBloc()),
        // BlocProvider(create: (context) => CertificateBloc()),
        BlocProvider(create: (context) => AppointmentBloc()),
        BlocProvider(create: (context) => MessageBloc()),
        BlocProvider(
          create: (context) {
            // Get the current user ID when available
            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            return CertificateBloc(
              // CertificateBloc()
              cloudinary: cloudinary,
              firestore: FirebaseFirestore.instance,
              doctorId: currentUserId ?? '', // Handle null case appropriately
            );
          },
        ),
        BlocProvider(
          create: (context) => OnboardingBloc(
            firestore: FirebaseFirestore.instance,
            auth: FirebaseAuth.instance,
            cloudinary: CloudinaryService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VistaCall',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      ),
    );
  }
}
