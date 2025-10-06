


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
        final patientId = participants.firstWhere((id) => id != doctorId, orElse: () => 'Unknown');
        print('Actual patientId from participants: $patientId'); // Debug actual ID

        final lastMessageDoc = await _db
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
        if (lastMessageDoc.docs.isNotEmpty) {
          final data = lastMessageDoc.docs.first.data() as Map<String, dynamic>;
          String patientName = 'Unknown';
          print('Initial patientName set to: $patientName');

          // Query the patients subcollection
          final patientDoc = await _db
              .collection('users')
              .doc(patientId.toString())
              .collection('patients')
              .get();
          if (patientDoc.docs.isNotEmpty) {
            final patientData = patientDoc.docs.first.data() as Map<String, dynamic>;
            final firstName = patientData['firstName'] ?? '';
            final lastName = patientData['lastName'] ?? '';
            patientName = '$firstName $lastName'.trim();
            print('Fetched patientName from patients subcollection: $patientName for patientId: $patientId');
          } else {
            print('No patients subcollection found for patientId: $patientId');
          }

          messages.add(
            MessageModel(
              senderName: patientName,
              time: (data['timestamp'] as Timestamp).toDate().toString(),
              messageCount: data['unreadCount'] ?? 0,
              patientId: patientId.toString(),
              message: data['message'] ?? 'No message',
              chatId: chatId,
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
    // final chatId = _getChatId(doctorId, event.patientId);
    // final timestamp = FieldValue.serverTimestamp();
    String patientId = event.patientId;

    print('SendMessage: Initial patientId: $patientId');
    final bookingsSnapshot = await _db
        .collection('users')
        .doc(doctorId)
        .collection('bookings')
        .where('userId', isEqualTo: patientId)
        .limit(1)
        .get();
        if(bookingsSnapshot.docs.isEmpty && event.patientId is String){
          final nameFallbackSnapshot = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('bookings')
          .where('userName', isEqualTo: event.patientId)
          .limit(1)
          .get();
          if(nameFallbackSnapshot.docs.isNotEmpty){
            patientId = nameFallbackSnapshot.docs.first.get('userId')  as String;
            print('SendMessage: Fallback patientId from userName: $patientId');
        }
        } else if(bookingsSnapshot.docs.isNotEmpty){
          patientId = bookingsSnapshot.docs.first.get('userId')  as String;
          print('SendMessage: Found patientId from userId: $patientId');
        } else {
          print('SendMessage: No matching booking found for patientId: $patientId');
        }

        final chatId = _getChatId(doctorId, patientId);
        final timestamp = FieldValue.serverTimestamp();

    print('Creating chat: $chatId with message: ${event.message} - patientId: ${event.patientId}');
    final chatDoc = await _db.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) {

    }
    await _db.collection('chats').doc(chatId).set({
      'participants': [doctorId, patientId], // Use UID
      'lastMessage': '',
      'timestamp': timestamp,
      'unreadCount': 0,
    });

    await _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': doctorId,
      'receiverId': patientId,
      'message': event.message,
      'timestamp': timestamp,
      'isRead': false,
    });

    await _db.collection('chats').doc(chatId).set({
    'lastMessage': event.message,
    'timestamp': timestamp,
    'unreadCount': FieldValue.increment(1),
  }, SetOptions(merge: true));

    add(LoadMessages());
  }

  String _getChatId(String doctorId, String patientId) {
    return doctorId.compareTo(patientId) < 0
        ? '$doctorId-$patientId'
        : '$patientId-$doctorId';
  }
}