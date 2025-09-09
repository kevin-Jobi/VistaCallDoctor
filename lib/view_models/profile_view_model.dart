


// view_models/doctor_profile_view_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_event.dart';

class DoctorProfileViewModel {
  final AuthBloc authBloc;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DoctorProfileViewModel(this.authBloc);

  void logout() {
    authBloc.add(SignOut());
  }

  Future<Map<String, dynamic>> getDoctorDetails() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      return {
        'name': 'Unknown',
        'specialization': 'N/A',
        'experience': 'N/A',
        'phone': 'N/A',
        'email': 'N/A',
        'category': 'N/A',
      };
    }

    final doctorId = user.uid;
    final doc = await _db.collection('doctors').doc(doctorId).get();
    if(doc.exists){
      final data = doc.data() ?? {};
      return {
        'name': data['name'] ?? user.displayName ?? 'Unknown',
        'specialization': data['specialization'] ?? 'N/A',
        'experience': data['experience']?.toString() ?? 'N/A',
        'phone': data['phone'] ?? 'N/A',
        'email': data['email'] ?? user.email ?? 'N/A',
        'category': data['category'] ?? 'N/A',
      };
    }
    return {
      'name': user.displayName ?? 'Unknown',
      'specialization': 'N/A',
      'experience': 'N/A',
      'phone': 'N/A',
      'email': user.email ?? 'N/A',
      'category': 'N/A',
    };
  }


}