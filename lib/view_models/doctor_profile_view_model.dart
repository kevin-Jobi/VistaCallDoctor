// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_event.dart';

// class DoctorProfileViewModel {
//   final AuthBloc authBloc;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   DoctorProfileViewModel(this.authBloc);

//   void logout() {
//     authBloc.add(SignOut());
//   }

//   Future<Map<String, dynamic>> getDoctorDetails() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return {
//         'name': 'Unknown',
//         'specialization': 'N/A',
//         'experience': 'N/A',
//         'phone': 'N/A',
//         'email': 'N/A',
//         'category': 'N/A',
//       };
//     }

//     final doctorId = user.uid;
//     final doc = await _db.collection('doctors').doc(doctorId).get();
//     if (doc.exists) {
//       final data = doc.data() ?? {};
//       return {
//         'name': data['name'] ?? user.displayName ?? 'Unknown',
//         'specialization': data['specialization'] ?? 'N/A',
//         'experience': data['experience']?.toString() ?? 'N/A',
//         'phone': data['phone'] ?? 'N/A',
//         'email': data['email'] ?? user.email ?? 'N/A',
//         'category': data['category'] ?? 'N/A',
//       };
//     }
//     return {
//       'name': user.displayName ?? 'Unknown',
//       'specialization': 'N/A',
//       'experience': 'N/A',
//       'phone': 'N/A',
//       'email': user.email ?? 'N/A',
//       'category': 'N/A',
//     };
//   }
// }

// ---------------------------------------------------------------------------------

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_event.dart';

// class DoctorProfileViewModel {
//   final AuthBloc authBloc;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   DoctorProfileViewModel(this.authBloc);

//   Future<Map<String, dynamic>> getDoctorDetails() async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         print('No authenticated user found');
//         return {
//           'personal': {
//             'fullName': 'Unknown',
//             'email': '',
//             'department': 'N/A',
//             'profileImageUrl': null,
//           },
//           'availability': {
//             'availableDays': [],
//             'availableTimeSlots': {},
//             'experience': 'N/A',
//             'fees': 'N/A',
//           },
//         };
//       }

//       final doctorId = user.uid;
//       print('Fetching data for doctorId: $doctorId');
//       final docSnapshot = await _firestore
//           .collection('doctors')
//           .doc(doctorId)
//           .get();

//       if (docSnapshot.exists) {
//         final data = docSnapshot.data() as Map<String, dynamic>;
//         print('Fetched data: $data');
//         final personal = data['personal'] as Map<String, dynamic>? ?? {};
//         final availability =
//             data['availability'] as Map<String, dynamic>? ?? {};

//         return {
//           // 'name':
//           //     personal['fullName'] ?? 'Unknown', // Use fullName from Firestore
//           // 'department':
//           //     personal['department'] ??
//           //     'N/A', // Assuming department is specialization
//           // 'email': personal['email'] ?? '',
//           // 'profileImageUrl': personal['profileImageUrl'],
//           // 'availability': {
//           //   'availableDays': List<String>.from(
//           //     availability['availableDays'] ?? [],
//           //   ),
//           //   'availableTimeSlots': Map<String, List<String>>.from(
//           //     availability['availableTimeSlots'] ?? {},
//           //   ),
//           //   'experience': availability['yearsOfExperience'] ?? 'N/A',
//           //   'fees': availability['fees'] ?? 'N/A',
//           // },
//           'personal': {
//             'fullName': personal['fullName'] ?? 'Unknown',
//             'email': personal['email'] ?? '',
//             'department': personal['department'] ?? 'N/A',
//             'profileImageUrl': personal['profileImageUrl'],
//             'phone':
//                 personal['phone'] ?? '+91 80866 38332', // Add phone if stored
//           },
//           'availability': {
//             'availableDays': List<String>.from(
//               availability['availableDays'] ?? [],
//             ),
//             'availableTimeSlots': Map<String, List<String>>.from(
//               availability['availableTimeSlots'] ?? {},
//             ),
//             'experience': availability['yearsOfExperience'] ?? 'N/A',
//             'fees': availability['fees'] ?? 'N/A',
//           },
//         };
//       }
//       // return {
//       //   'name': 'Unknown',
//       //   'department': 'N/A',
//       //   'email': '',
//       //   'profileImageUrl': null,
//       //   'phone': '+91 80766 38312',
//       //   'availability': {
//       //     'availableDays': [],
//       //     'availableTimeSlots': {},
//       //     'experience': 'N/A',
//       //     'fees': 'N/A',
//       //   },
//       // };
//       print('No document found for doctorId: $doctorId');
//       return {
//         'personal': {
//           'fullName': 'Unknown',
//           'email': '',
//           'department': 'N/A',
//           'profileImageUrl': null,
//         },
//         'availability': {
//           'availableDays': [],
//           'availableTimeSlots': {},
//           'experience': 'N/A',
//           'fees': 'N/A',
//         },
//       };
//     } catch (e) {
//       print('Error fetching doctor details: $e');
//       return {
//         // 'name': 'Unknown',
//         // 'department': 'N/A',
//         // 'email': '',
//         // 'phone': '+91 80766 38312',
//         // 'profileImageUrl': null,
//         // 'availability': {
//         //   'availableDays': [],
//         //   'availableTimeSlots': {},
//         //   'experience': 'N/A',
//         //   'fees': 'N/A',
//         // },
//         'personal': {
//           'fullName': 'Unknown',
//           'email': '',
//           'department': 'N/A',
//           'profileImageUrl': null,
//         },
//         'availability': {
//           'availableDays': [],
//           'availableTimeSlots': {},
//           'experience': 'N/A',
//           'fees': 'N/A',
//         },
//       };
//     }
//   }

//   void logout() {
//     // authBloc.add(AuthLogoutRequested()); // Trigger logout event in AuthBloc
//     authBloc.add(SignOut());
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_event.dart';

class DoctorProfileViewModel {
  final AuthBloc authBloc;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DoctorProfileViewModel(this.authBloc);

  Future<Map<String, dynamic>> getDoctorDetails() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        return {
          'personal': {
            'fullName': 'Unknown',
            'email': '',
            'department': 'N/A',
            'profileImageUrl': null,
            'phone': '+91 80866 38223',
          },
          'availability': {
            'availableDays': [],
            'availableTimeSlots': {},
            'experience': 'N/A',
            'fees': 'N/A',
          },
        };
      }

      final doctorId = user.uid;
      print('Fetching data for doctorId: $doctorId');
      final docSnapshot = await _firestore
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        print('Fetched data: $data');
        final personal = data['personal'] as Map<String, dynamic>? ?? {};
        final availability =
            data['availability'] as Map<String, dynamic>? ?? {};

        // Safely convert dynamic lists and maps
        List<String> convertToStringList(dynamic list) {
          return (list as List?)?.map((item) => item.toString()).toList() ?? [];
        }

        Map<String, List<String>> convertToTimeSlotsMap(dynamic map) {
          if (map is! Map) return {};
          return (map as Map).map((key, value) {
            final k = key.toString();
            final v =
                (value as List?)?.map((item) => item.toString()).toList() ?? [];
            return MapEntry(k, v);
          });
        }

        return {
          'personal': {
            'fullName': personal['fullName']?.toString() ?? 'Unknown',
            'email': personal['email']?.toString() ?? '',
            'department': personal['department']?.toString() ?? 'N/A',
            'profileImageUrl': personal['profileImageUrl']?.toString(),
            'phone': personal['phone']?.toString() ?? '+91 80866 38332',
          },
          'availability': {
            'availableDays': convertToStringList(availability['availableDays']),
            'availableTimeSlots': convertToTimeSlotsMap(
              availability['availableTimeSlots'],
            ),
            'experience':
                availability['yearsOfExperience']?.toString() ?? 'N/A',
            'fees': availability['fees']?.toString() ?? 'N/A',
          },
        };
      }
      print('No document found for doctorId: $doctorId');
      return {
        'personal': {
          'fullName': 'Unknown',
          'email': '',
          'department': 'N/A',
          'profileImageUrl': null,
          'phone': '+91 80866 38332',
        },
        'availability': {
          'availableDays': [],
          'availableTimeSlots': {},
          'experience': 'N/A',
          'fees': 'N/A',
        },
      };
    } catch (e) {
      print('Error fetching doctor details: $e');
      return {
        'personal': {
          'fullName': 'Unknown',
          'email': '',
          'department': 'N/A',
          'profileImageUrl': null,
          'phone': '+91 80866 38332',
        },
        'availability': {
          'availableDays': [],
          'availableTimeSlots': {},
          'experience': 'N/A',
          'fees': 'N/A',
        },
      };
    }
  }

  Future<void> updateProfileImage(String newImageUrl) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    await _firestore.collection('doctors').doc(doctorId).update({
      'personal.profileImageUrl': newImageUrl,
    });
  }

  Future<void> updateName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    await _firestore.collection('doctors').doc(doctorId).update({
      'personal.fullName': newName,
    });
  }

  Future<void> updateExperience(String newExperience) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    await _firestore.collection('doctors').doc(doctorId).update({
      'availability.yearsOfExperience': newExperience,
    });
  }

  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    await _firestore.collection('doctors').doc(doctorId).update({
      'personal.email': newEmail,
    });
  }

  Future<void> updateSpecialization(String newSpecialization) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    await _firestore.collection('doctors').doc(doctorId).update({
      'personal.department': newSpecialization,
    });
  }

  Future<void> updatePhone(String newPhone) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final doctorId = user.uid;
    await _firestore.collection('doctors').doc(doctorId).update({
      'personal.phone': newPhone,
    });
  }

  void logout() {
    // authBloc.add(AuthLogoutRequested()); // Trigger logout event in AuthBloc
    authBloc.add(SignOut());
  }
}
