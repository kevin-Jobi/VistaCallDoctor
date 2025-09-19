import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/message/message_bloc.dart';
import 'package:vista_call_doctor/models/message_model.dart';
import 'package:vista_call_doctor/view_models/message_view_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const ChatDetailScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = MessageViewModel(BlocProvider.of<MessageBloc>(context));
    final doctorId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection('chats')
                  .doc(_getChatId(doctorId, widget.patientId))
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final timestamp = data['timestamp'] as Timestamp?;
                  final senderId = data['senderId'] as String;
                  final isDoctor = senderId == doctorId;
                  final senderName = isDoctor ? 'You' : widget.patientName;
                  final time = timestamp != null ? timestamp.toDate().toString() : 'Unknown time';
                  final messageContent = data['message'] ?? 'No message content';
                  return MessageModel(
                    // senderName: data['senderId'] == doctorId ? 'You' : widget.patientName,
                    // time: (data['timestamp'] as Timestamp).toDate().toString(),
                    // messageCount: 1, // Adjust based on unread status
                    // patientId: widget.patientId, // Pass the patientId from the widget
                    // message: data['message'] ?? 'No message',
                    senderName: senderName,
                    time: time,
                    messageCount: 1, // Adjust based on unread status
                    patientId: widget.patientId,
                    message: messageContent, 
                  );
                }).toList();
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) => ListTile(
                    // title: Text(messages[index].senderName),
                    title: Text(messages[index].message),
                    subtitle: Text(messages[index].time),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      viewModel.sendMessage(widget.patientId, _messageController.text);
                      _messageController.clear();
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getChatId(String doctorId, String patientId) {
    return doctorId.compareTo(patientId) < 0
        ? '$doctorId-$patientId'
        : '$patientId-$doctorId';
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/message/message_bloc.dart';
// import 'package:vista_call_doctor/models/message_model.dart';
// import 'package:vista_call_doctor/view_models/message_view_model.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final String patientId; // Currently a name, e.g., "Anuraj"
//   final String patientName;

//   const ChatDetailScreen({
//     super.key,
//     required this.patientId,
//     required this.patientName,
//   });

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = MessageViewModel(BlocProvider.of<MessageBloc>(context));
//     final doctorId = _auth.currentUser?.uid ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.patientName),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _db
//                   .collection('chats')
//                   .doc(_getChatId(doctorId, widget.patientId))
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data!.docs.map((doc) {
//                   final data = doc.data() as Map<String, dynamic>;
//                   final timestamp = data['timestamp'] as Timestamp?;
//                   final senderId = data['senderId'] as String;
//                   final isDoctor = senderId == doctorId;
//                   final senderName = isDoctor ? 'You' : widget.patientName;
//                   final time = timestamp != null ? timestamp.toDate().toString() : 'Unknown time';
//                   final messageContent = data['message'] ?? 'No message content';
//                   return MessageModel(
//                     senderName: senderName,
//                     time: time,
//                     messageCount: 1,
//                     patientId: widget.patientId,
//                     message: messageContent,
//                   );
//                 }).toList();
//                 return ListView.builder(
//                   controller: _scrollController,
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) => ListTile(
//                     title: Text(messages[index].senderName),
//                     subtitle: Text(messages[index].message),
//                     trailing: Text(messages[index].time),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(hintText: 'Type a message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () async {
//                     if (_messageController.text.isNotEmpty) {
//                       // Debug: Log a sample of users collection
//                       final allUsers = await _db.collection('users').limit(5).get();
//                       print('Sample users collection: ${allUsers.docs.map((d) => d.data())}');

//                       // Query users collection with multiple possible field names
//                       final possibleFields = ['name', 'displayName', 'username', 'fullName'];
//                       String? patientUid;
//                       for (final field in possibleFields) {
//                         final patientDoc = await _db
//                             .collection('users')
//                             .where(field, isEqualTo: widget.patientName)
//                             .limit(1)
//                             .get();
//                         print('Query result for ${widget.patientName} on $field: ${patientDoc.docs.map((d) => d.data())}');
//                         if (patientDoc.docs.isNotEmpty) {
//                           patientUid = patientDoc.docs.first.id;
//                           print('Found UID via $field: $patientUid');
//                           break;
//                         }
//                       }
//                       if (patientUid == null) {
//                         print('Error: No UID found for patientName: ${widget.patientName} in any field');
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Patient not found. Check user data.')),
//                         );
//                         return;
//                       }
//                       print('Resolved patientUid: $patientUid for patientName: ${widget.patientName}');
//                       viewModel.sendMessage(patientUid, _messageController.text);
//                       _messageController.clear();
//                       _scrollController.animateTo(
//                         0,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeOut,
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getChatId(String doctorId, String patientId) {
//     return doctorId.compareTo(patientId) < 0
//         ? '$doctorId-$patientId'
//         : '$patientId-$doctorId';
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/message/message_bloc.dart';
// import 'package:vista_call_doctor/models/message_model.dart';
// import 'package:vista_call_doctor/view_models/message_view_model.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final String patientId; // Currently a name, e.g., "Anuraj"
//   final String patientName;

//   const ChatDetailScreen({
//     super.key,
//     required this.patientId,
//     required this.patientName,
//   });

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = MessageViewModel(BlocProvider.of<MessageBloc>(context));
//     final doctorId = _auth.currentUser?.uid ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.patientName),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _db
//                   .collection('chats')
//                   .doc(_getChatId(doctorId, widget.patientId))
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data!.docs.map((doc) {
//                   final data = doc.data() as Map<String, dynamic>;
//                   final timestamp = data['timestamp'] as Timestamp?;
//                   final senderId = data['senderId'] as String;
//                   final isDoctor = senderId == doctorId;
//                   final senderName = isDoctor ? 'You' : widget.patientName;
//                   final time = timestamp != null ? timestamp.toDate().toString() : 'Unknown time';
//                   final messageContent = data['message'] ?? 'No message content';
//                   return MessageModel(
//                     senderName: senderName,
//                     time: time,
//                     messageCount: 1,
//                     patientId: widget.patientId,
//                     message: messageContent,
//                   );
//                 }).toList();
//                 return ListView.builder(
//                   controller: _scrollController,
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) => ListTile(
//                     title: Text(messages[index].message),
//                     subtitle: Text(messages[index].time),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(hintText: 'Type a message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () async {
//                     if (_messageController.text.isNotEmpty) {
//                       // Query appointments to find UID based on patientName
//                       final appointmentDoc = await _db
//                           .collection('appointments')
//                           .where('userName', isEqualTo: widget.patientName)
//                           .limit(1)
//                           .get();
//                       final String? patientUid = appointmentDoc.docs.isNotEmpty
//                           ? appointmentDoc.docs.first.get('userId') as String?
//                           : null;
//                       if (patientUid == null) {
//                         print('Error: No UID found for patientName: ${widget.patientName} in appointments');
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Patient not found. Check appointment data.')),
//                         );
//                         return;
//                       }
//                       print('Resolved patientUid: $patientUid for patientName: ${widget.patientName}');
//                       viewModel.sendMessage(patientUid, _messageController.text);
//                       _messageController.clear();
//                       _scrollController.animateTo(
//                         0,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeOut,
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getChatId(String doctorId, String patientId) {
//     return doctorId.compareTo(patientId) < 0
//         ? '$doctorId-$patientId'
//         : '$patientId-$doctorId';
//   }
// }