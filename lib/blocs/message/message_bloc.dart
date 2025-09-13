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
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, error: 'User not authenticated'));
        return;
      }

      final doctorId = user.uid;
      final chatsSnapshot = await _db
          .collection('chats')
          .where('participants', arrayContains: doctorId)
          .get();

      final messages = <MessageModel>[];
      for (var chatDoc in chatsSnapshot.docs) {
        final chatId = chatDoc.id;
        final [patientId, _] = chatId
            .split('-')
            .where((id) => id != doctorId)
            .toList();
        final lastMessageDoc = await _db
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
        if (lastMessageDoc.docs.isNotEmpty) {
          final data = lastMessageDoc.docs.first.data() as Map<String, dynamic>;
          // final patientId = chatDoc.id
          //     .split('-')
          //     .firstWhere((id) => id != doctorId);
          final patientName = await _db
              .collection('users')
              .doc(patientId)
              .get()
              .then((doc) => doc.data()?['name'] ?? 'Unknown');
          messages.add(
            MessageModel(
              senderName: patientName,
              time: (data['timestamp'] as Timestamp).toDate().toString(),
              messageCount: data['unreadCount'] ?? 0,
              patientId: patientId,
            ),
          );
        }
      }

      emit(state.copyWith(messages: messages, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Failed to load messages: $e'),
      );
    }
    // await Future.delayed(const Duration(seconds: 2));
    // final messages = [
    //   MessageModel(senderName: 'Shahad', time: '11:00 AM', messageCount: 2),
    //   MessageModel(senderName: 'Akhil', time: '11:00 AM', messageCount: 2),
    //   MessageModel(senderName: 'Najin', time: '11:00 AM', messageCount: 2),
    // ];
    // emit(state.copyWith(messages: messages, isLoading: false));
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

    await _db.collection('chats').doc(chatId).set({
      'participants': [doctorId, event.patientId],
      'lastMessage': event.message,
      'timestamp': timestamp,
      'unreadCount': 0,
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
