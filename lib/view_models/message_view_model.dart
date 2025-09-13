import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../blocs/message/message_bloc.dart';
import '../blocs/message/message_event.dart';

class MessageViewModel {
  final MessageBloc messageBloc;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  MessageViewModel(this.messageBloc);

  void loadMessages() {
    messageBloc.add(const LoadMessages());
  }

  Future<void> sendMessage(String patientId, String message)async{
    messageBloc.add(SendMessage(patientId, message));

    // final user = _auth.currentUser;
    // if(user == null) return;

    // final doctorId = user.uid;
    // final chatId = _getChatId(doctorId, patientId);
    // final timestamp = FieldValue.serverTimestamp();

    // await _db.collection('chats').doc(chatId).collection('messages').add({
    //   'senderId': doctorId,
    //   'receiverId': patientId,
    //   'message': message,
    //   'timestamp': timestamp,
    //   'isRead': false
    // });

    // // Update message count or last message for UI
    // await _db.collection('chats').doc(chatId).set({
    //   'lastMessage': message,
    //   'timestamp': timestamp,
    //   'unreadCount': FieldValue.increment(1),
    // },SetOptions(merge: true));
  }

  String _getChatId(String doctorId, String patientId) {
    return doctorId.compareTo(patientId)<0
    ? '$doctorId-$patientId'
    : '$patientId-$doctorId';
  }
}
