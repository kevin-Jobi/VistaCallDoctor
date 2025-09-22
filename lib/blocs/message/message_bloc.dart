// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'message_event.dart';
// import 'message_state.dart';
// import '../../models/message_model.dart';

// class MessageBloc extends Bloc<MessageEvent, MessageState> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   MessageBloc() : super(const MessageState()) {
//     on<LoadMessages>(_onLoadMessages);
//     on<SendMessage>(_onSendMessage);
//   }

//   Future<void> _onLoadMessages(LoadMessages event, Emitter emit) async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         emit(state.copyWith(isLoading: false, error: 'User not authenticated'));
//         return;
//       }

//       final doctorId = user.uid;
//       final chatsSnapshot = await _db
//           .collection('chats')
//           .where('participants', arrayContains: doctorId)
//           .get();

//         print('Found ${chatsSnapshot.docs.length} chat documents'); // Debug log
//       final messages = <MessageModel>[];
//       for (var chatDoc in chatsSnapshot.docs) {
//         final chatId = chatDoc.id;
//         final [patientId, _] = chatId
//             .split('-')
//             .where((id) => id != doctorId)
//             .toList();
//         final lastMessageDoc = await _db
//             .collection('chats')
//             .doc(chatId)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .limit(1)
//             .get();
//         if (lastMessageDoc.docs.isNotEmpty) {
//           final data = lastMessageDoc.docs.first.data() as Map<String, dynamic>;
//           // final patientId = chatDoc.id
//           //     .split('-')
//           //     .firstWhere((id) => id != doctorId);
//           final patientName = await _db
//               .collection('users')
//               .doc(patientId)
//               .get()
//               .then((doc) => doc.data()?['name'] ?? 'Unknown');
//           messages.add(
//             MessageModel(
//               senderName: patientName,
//               time: (data['timestamp'] as Timestamp).toDate().toString(),
//               messageCount: data['unreadCount'] ?? 0,
//               patientId: patientId,
//               message: data['message'] ?? 'No message'
//             ),
//           );
//         } else{
//           print('No messages found in chat: $chatId'); // Debug missing messages
//         }
//       }

//       emit(state.copyWith(messages: messages, isLoading: false));
//     } catch (e) {
//       print('LoadMessages error: $e'); // Debug error
//       emit(
//         state.copyWith(isLoading: false, error: 'Failed to load messages: $e'),
//       );
//     }
//     // await Future.delayed(const Duration(seconds: 2));
//     // final messages = [
//     //   MessageModel(senderName: 'Shahad', time: '11:00 AM', messageCount: 2),
//     //   MessageModel(senderName: 'Akhil', time: '11:00 AM', messageCount: 2),
//     //   MessageModel(senderName: 'Najin', time: '11:00 AM', messageCount: 2),
//     // ];
//     // emit(state.copyWith(messages: messages, isLoading: false));
//   }

//   Future<void> _onSendMessage(
//     SendMessage event,
//     Emitter<MessageState> emit,
//   ) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     final doctorId = user.uid;
//     final chatId = _getChatId(doctorId, event.patientId);
//     final timestamp = FieldValue.serverTimestamp();
    
//     print('Creating chat: $chatId with message: ${event.message}'); // Debug log
//     await _db.collection('chats').doc(chatId).set({
//       'participants': [doctorId, event.patientId],
//       'lastMessage': event.message,
//       'timestamp': timestamp,
//       'unreadCount': 0,
//     }, SetOptions(merge: true));

//     await _db.collection('chats').doc(chatId).collection('messages').add({
//       'senderId': doctorId,
//       'receiverId': event.patientId,
//       'message': event.message,
//       'timestamp': timestamp,
//       'isRead': false,
//     });

//     add(LoadMessages());
//   }

//   String _getChatId(String doctorId, String patientId) {
//     return doctorId.compareTo(patientId) < 0
//         ? '$doctorId-$patientId'
//         : '$patientId-$doctorId';
//   }
// }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'message_event.dart';
// import 'message_state.dart';
// import '../../models/message_model.dart';

// class MessageBloc extends Bloc<MessageEvent, MessageState> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   MessageBloc() : super(const MessageState()) {
//     on<LoadMessages>(_onLoadMessages);
//     on<SendMessage>(_onSendMessage);
//   }

//   Future<void> _onLoadMessages(LoadMessages event, Emitter emit) async {
//     emit(state.copyWith(isLoading: true));
//     QuerySnapshot? chatsSnapshot; // Declare outside try block
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         emit(state.copyWith(isLoading: false, error: 'User not authenticated'));
//         return;
//       }

//       final doctorId = user.uid;
//       chatsSnapshot = await _db
//           .collection('chats')
//           .where('participants', arrayContains: doctorId)
//           .get();

//       print('Found ${chatsSnapshot.docs.length} chat documents: ${chatsSnapshot.docs.map((d) => d.id).join(', ')}');
//       final messages = <MessageModel>[];
//       for (var chatDoc in chatsSnapshot.docs) {
//         final chatId = chatDoc.id;
//         final ids = chatId.split('-');
//         final patientId = ids.firstWhere((id) => id != doctorId, orElse: () => ids.firstWhere((id) => id != '', orElse: () => 'Unknown'));
//         final lastMessageDoc = await _db
//             .collection('chats')
//             .doc(chatId)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .limit(1)
//             .get();
//         if (lastMessageDoc.docs.isNotEmpty) {
//           final data = lastMessageDoc.docs.first.data() as Map<String, dynamic>;
//           final patientName = await _db
//               .collection('users')
//               .doc(patientId)
//               .get()
//               .then((doc) => doc.data()?['name'] ?? 'Unknown');
//           messages.add(
//             MessageModel(
//               senderName: patientName,
//               time: (data['timestamp'] as Timestamp).toDate().toString(),
//               messageCount: data['unreadCount'] ?? 0,
//               patientId: patientId,
//               message: data['message'] ?? 'No message',
//             ),
//           );
//         } else {
//           print('No messages found in chat: $chatId');
//         }
//       }

//       emit(state.copyWith(messages: messages, isLoading: false));
//     } catch (e) {
//       print('LoadMessages error: $e - Chat data: ${chatsSnapshot?.docs.map((d) => d.data()).join(', ') ?? 'No data available'}');
//       emit(state.copyWith(isLoading: false, error: 'Failed to load messages: $e'));
//     }
//   }

//   Future<void> _onSendMessage(
//     SendMessage event,
//     Emitter<MessageState> emit,
//   ) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     final doctorId = user.uid;
//     final chatId = _getChatId(doctorId, event.patientId);
//     final timestamp = FieldValue.serverTimestamp();

//     print('Creating chat: $chatId with message: ${event.message}');
//     await _db.collection('chats').doc(chatId).set({
//       'participants': [doctorId, event.patientId],
//       'lastMessage': event.message,
//       'timestamp': timestamp,
//       'unreadCount': 0,
//     }, SetOptions(merge: true));

//     await _db.collection('chats').doc(chatId).collection('messages').add({
//       'senderId': doctorId,
//       'receiverId': event.patientId,
//       'message': event.message,
//       'timestamp': timestamp,
//       'isRead': false,
//     });

//     add(LoadMessages()); // Trigger reload
//   }

//   String _getChatId(String doctorId, String patientId) {
//     return doctorId.compareTo(patientId) < 0
//         ? '$doctorId-$patientId'
//         : '$patientId-$doctorId';
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'message_event.dart';
// import 'message_state.dart';
// import '../../models/message_model.dart';

// class MessageBloc extends Bloc<MessageEvent, MessageState> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   MessageBloc() : super(const MessageState()) {
//     on<LoadMessages>(_onLoadMessages);
//     on<SendMessage>(_onSendMessage);
//   }

//   Future<void> _onLoadMessages(LoadMessages event, Emitter emit) async {
//     emit(state.copyWith(isLoading: true));
//     QuerySnapshot? chatsSnapshot;
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         emit(state.copyWith(isLoading: false, error: 'User not authenticated'));
//         return;
//       }

//       final doctorId = user.uid;
//       chatsSnapshot = await _db
//           .collection('chats')
//           .where('participants', arrayContains: doctorId)
//           .get();

//       print('Found ${chatsSnapshot.docs.length} chat documents: ${chatsSnapshot.docs.map((d) => d.id).join(', ')}');
//       final messages = <MessageModel>[];
//       for (var chatDoc in chatsSnapshot.docs) {
//         final chatId = chatDoc.id;
//         final participantData = chatDoc.data() as Map<String, dynamic>;
//         final participants = participantData['participants'] as List<dynamic>;
//         final actualPatientId = participants.firstWhere((id) => id != doctorId, orElse: () => 'Unknown');
//         print('Actual patientId from participants: $actualPatientId'); // Debug actual ID
//         final lastMessageDoc = await _db
//             .collection('chats')
//             .doc(chatId)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .limit(1)
//             .get();
//         if (lastMessageDoc.docs.isNotEmpty) {
//           final data = lastMessageDoc.docs.first.data() as Map<String, dynamic>;
//           final patientDoc = await _db.collection('users').doc(actualPatientId.toString()).get();
//           String patientName;
//           if (patientDoc.exists) {
//             patientName = patientDoc.data()?['name'] ?? 'Unknown';
//           } else {
//             patientName = 'Unknown';
//           }
//           print('Fetched patientName: $patientName for patientId: $actualPatientId'); // Debug name
//           messages.add(
//             MessageModel(
//               senderName: patientName,
//               time: (data['timestamp'] as Timestamp).toDate().toString(),
//               messageCount: data['unreadCount'] ?? 0,
//               patientId: actualPatientId.toString(),
//               message: data['message'] ?? 'No message',
//             ),
//           );
//         } else {
//           print('No messages found in chat: $chatId');
//         }
//       }

//       emit(state.copyWith(messages: messages, isLoading: false));
//     } catch (e) {
//       print('LoadMessages error: $e - Chat data: ${chatsSnapshot?.docs.map((d) => d.data()).join(', ') ?? 'No data available'}');
//       emit(state.copyWith(isLoading: false, error: 'Failed to load messages: $e'));
//     }
//   }

//   Future<void> _onSendMessage(
//     SendMessage event,
//     Emitter<MessageState> emit,
//   ) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     final doctorId = user.uid;
//     final chatId = _getChatId(doctorId, event.patientId);
//     final timestamp = FieldValue.serverTimestamp();

//     print('Creating chat: $chatId with message: ${event.message} - patientId: ${event.patientId}');
//     await _db.collection('chats').doc(chatId).set({
//       'participants': [doctorId, event.patientId], // Use UID
//       'lastMessage': event.message,
//       'timestamp': timestamp,
//       'unreadCount': 0,
//     }, SetOptions(merge: true));

//     await _db.collection('chats').doc(chatId).collection('messages').add({
//       'senderId': doctorId,
//       'receiverId': event.patientId,
//       'message': event.message,
//       'timestamp': timestamp,
//       'isRead': false,
//     });

//     add(LoadMessages());
//   }

//   String _getChatId(String doctorId, String patientId) {
//     return doctorId.compareTo(patientId) < 0
//         ? '$doctorId-$patientId'
//         : '$patientId-$doctorId';
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'message_event.dart';
import 'message_state.dart';
import '../../models/message_model.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MessageBloc() : super(const MessageState()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    QuerySnapshot? chatsSnapshot;
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, error: 'User not authenticated'));
        return;
      }

      final doctorId = user.uid;
      chatsSnapshot = await _db
          .collection('chats')
          .where('participants', arrayContains: doctorId)
          .get();

      print('Found ${chatsSnapshot.docs.length} chat documents: ${chatsSnapshot.docs.map((d) => d.id).join(', ')}');
      final messages = <MessageModel>[];
      for (var chatDoc in chatsSnapshot.docs) {
        final chatId = chatDoc.id;
        final participantData = chatDoc.data() as Map<String, dynamic>;
        final participants = participantData['participants'] as List<dynamic>;
        final actualPatientId = participants.firstWhere((id) => id != doctorId, orElse: () => 'Unknown');
        print('Actual patientId from participants: $actualPatientId'); // Debug actual ID

        final lastMessageDoc = await _db
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
        if (lastMessageDoc.docs.isNotEmpty) {
          final data = lastMessageDoc.docs.first.data() as Map<String, dynamic>;
          // String patientName = 'Unknown';
          String patientName = actualPatientId;
          print('Initial patientName set to:$patientName');
          // First, try users collection
          final patientDoc = await _db.collection('users').doc(actualPatientId.toString()).get();
          if (patientDoc.exists) {
            patientName = patientDoc.data()?['name'] ?? 'Unknown';
            print('Fetched patientName from users: $patientName for patientId: $actualPatientId');
          } else {
            print('No user doc found for patientId: $actualPatientId, checking appointments...');
            // Fallback: Query appointments for userName
            final appointmentDoc = await _db
                .collection('appointments')
                .where('userId', isEqualTo: actualPatientId.toString())
                .limit(1)
                .get();
            if (appointmentDoc.docs.isNotEmpty) {
              patientName = appointmentDoc.docs.first.get('userName') as String? ?? 'Unknown';
              print('Fetched patientName from appointments: $patientName for patientId: $actualPatientId');
            } else {
              print('No appointment data found for patientId: $actualPatientId');
            }
          }
          messages.add(
            MessageModel(
              senderName: patientName,
              time: (data['timestamp'] as Timestamp).toDate().toString(),
              messageCount: data['unreadCount'] ?? 0,
              patientId: actualPatientId.toString(),
              message: data['message'] ?? 'No message',
            ),
          );
        } else {
          print('No messages found in chat: $chatId');
        }
      }

      emit(state.copyWith(messages: messages, isLoading: false));
    } catch (e) {
      print('LoadMessages error: $e - Chat data: ${chatsSnapshot?.docs.map((d) => d.data()).join(', ') ?? 'No data available'}');
      emit(state.copyWith(isLoading: false, error: 'Failed to load messages: $e'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doctorId = user.uid;
    final chatId = _getChatId(doctorId, event.patientId);
    final timestamp = FieldValue.serverTimestamp();

    print('Creating chat: $chatId with message: ${event.message} - patientId: ${event.patientId}');
    await _db.collection('chats').doc(chatId).set({
      'participants': [doctorId, event.patientId], // Use UID
      'lastMessage': event.message,
      'timestamp': timestamp,
      'unreadCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    await _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': doctorId,
      'receiverId': event.patientId,
      'message': event.message,
      'timestamp': timestamp,
      'isRead': false,
    });

    add(LoadMessages());
  }

  String _getChatId(String doctorId, String patientId) {
    return doctorId.compareTo(patientId) < 0
        ? '$doctorId-$patientId'
        : '$patientId-$doctorId';
  }
}