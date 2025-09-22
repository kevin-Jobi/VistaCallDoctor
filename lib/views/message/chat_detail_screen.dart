// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/message/message_bloc.dart';
// import 'package:vista_call_doctor/models/message_model.dart';
// import 'package:vista_call_doctor/view_models/message_view_model.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final String patientId;
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
//                   final time = timestamp != null ? timestamp.toDate().toString() : 'Pending...';
//                   final messageContent = data['message'] ?? 'No message content';
//                   print('Message data: senderId=$senderId, message=$messageContent, time=$time'); // Debug
//                   return MessageModel(
//                     // senderName: data['senderId'] == doctorId ? 'You' : widget.patientName,
//                     // time: (data['timestamp'] as Timestamp).toDate().toString(),
//                     // messageCount: 1, // Adjust based on unread status
//                     // patientId: widget.patientId, // Pass the patientId from the widget
//                     // message: data['message'] ?? 'No message',
//                     senderName: senderName,
//                     time: time,
//                     messageCount: 1, // Adjust based on unread status
//                     patientId: widget.patientId,
//                     message: messageContent, 
//                   );
//                 }).toList();
//                 print('Total messages fetched: ${messages.length}'); // Debug
//                 return ListView.builder(
//                   controller: _scrollController,
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) => ListTile(
//                     // title: Text(messages[index].senderName),
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
//                     final chatsSnapshot = await _db
//                           .collection('chats')
//                           .where('participants', arrayContains: widget.patientId)
//                           .limit(1)
//                           .get();
//                       print('Chat query result for ${widget.patientId}: ${chatsSnapshot.docs.map((d) => d.data())}');
//                     if (_messageController.text.isNotEmpty) {
//                       final chatId = _getChatId(doctorId, widget.patientId);
//                       if(chatsSnapshot.docs.isEmpty){
//                         await _db.collection('chats').doc(chatId).set({
//                           'participants': [doctorId,widget.patientId],
//                           'lastMessage':'',
//                           'timestamp':FieldValue.serverTimestamp(),
//                           'unreadCount':0
//                         });
//                       }
//                       viewModel.sendMessage(widget.patientId, _messageController.text);
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


// ------------------------------------------------


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/message/message_bloc.dart';
// import 'package:vista_call_doctor/models/message_model.dart';
// import 'package:vista_call_doctor/view_models/message_view_model.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final String patientId;
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
//   final FocusNode _textFieldFocus = FocusNode();

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _textFieldFocus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = MessageViewModel(BlocProvider.of<MessageBloc>(context));
//     final doctorId = _auth.currentUser?.uid ?? '';

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFE),
//       appBar: _buildAppBar(context),
//       body: Column(
//         children: [
//           Expanded(
//             child: _buildMessagesStream(doctorId),
//           ),
//           _buildMessageInput(viewModel, doctorId),
//         ],
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
//       title: Row(
//         children: [
//           _buildPatientAvatar(),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.patientName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//                 Text(
//                   'Online now',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(right: 8),
//           child: _buildCallButton(context),
//         ),
//         Container(
//           margin: const EdgeInsets.only(right: 16),
//           child: _buildMoreButton(context),
//         ),
//       ],
//     );
//   }

//   Widget _buildPatientAvatar() {
//     final initials = _getInitials(widget.patientName);
    
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF10B981), Color(0xFF059669)],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF10B981).withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: initials.isNotEmpty
//           ? Center(
//               child: Text(
//                 initials,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             )
//           : const Icon(
//               Icons.person,
//               color: Colors.white,
//               size: 20,
//             ),
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

//   Widget _buildCallButton(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         color: const Color(0xFF10B981).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: IconButton(
//         onPressed: () {
//           // Add call functionality
//         },
//         icon: const Icon(
//           Icons.video_call,
//           color: Color(0xFF10B981),
//           size: 20,
//         ),
//       ),
//     );
//   }

//   Widget _buildMoreButton(BuildContext context) {
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
//           // Add more options functionality
//         },
//         icon: const Icon(
//           Icons.more_vert,
//           color: Color(0xFF6B7280),
//           size: 20,
//         ),
//       ),
//     );
//   }

//   Widget _buildMessagesStream(String doctorId) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFFF8FAFE),
//       ),
//       child: StreamBuilder<QuerySnapshot>(
//         stream: _db
//             .collection('chats')
//             .doc(_getChatId(doctorId, widget.patientId))
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return _buildLoadingState();
//           }

//           final messages = snapshot.data!.docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             final timestamp = data['timestamp'] as Timestamp?;
//             final senderId = data['senderId'] as String;
//             final isDoctor = senderId == doctorId;
//             final senderName = isDoctor ? 'You' : widget.patientName;
//             final time = timestamp != null ? timestamp.toDate().toString() : 'Pending...';
//             final messageContent = data['message'] ?? 'No message content';
            
//             print('Message data: senderId=$senderId, message=$messageContent, time=$time');
            
//             return MessageModel(
//               senderName: senderName,
//               time: time,
//               messageCount: 1,
//               patientId: widget.patientId,
//               message: messageContent,
//             );
//           }).toList();

//           print('Total messages fetched: ${messages.length}');

//           if (messages.isEmpty) {
//             return _buildEmptyState();
//           }

//           return ListView.builder(
//             controller: _scrollController,
//             reverse: true,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             itemCount: messages.length,
//             itemBuilder: (context, index) => _buildMessageBubble(
//               messages[index],
//               doctorId,
//               index == 0 || _shouldShowTimestamp(messages, index),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return const Center(
//       child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
//         strokeWidth: 3,
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             height: 80,
//             width: 80,
//             decoration: BoxDecoration(
//               color: const Color(0xFF667EEA).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.chat_bubble_outline,
//               size: 40,
//               color: Color(0xFF667EEA),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Start the conversation',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Send a message to ${widget.patientName}',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _shouldShowTimestamp(List<MessageModel> messages, int index) {
//     if (index == messages.length - 1) return true;
    
//     // Show timestamp if messages are more than 1 hour apart
//     final currentMessage = messages[index];
//     final nextMessage = messages[index + 1];
    
//     try {
//       final currentTime = DateTime.parse(currentMessage.time);
//       final nextTime = DateTime.parse(nextMessage.time);
//       return currentTime.difference(nextTime).inHours >= 1;
//     } catch (e) {
//       return false;
//     }
//   }

//   Widget _buildMessageBubble(MessageModel message, String doctorId, bool showTimestamp) {
//     final isFromDoctor = message.senderName == 'You';
    
//     return Column(
//       crossAxisAlignment: isFromDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         if (showTimestamp) _buildTimestampDivider(message.time),
//         Container(
//           margin: EdgeInsets.only(
//             bottom: 8,
//             left: isFromDoctor ? 60 : 0,
//             right: isFromDoctor ? 0 : 60,
//           ),
//           child: Column(
//             crossAxisAlignment: isFromDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   gradient: isFromDoctor
//                       ? const LinearGradient(
//                           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                         )
//                       : null,
//                   color: isFromDoctor ? null : Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(20),
//                     topRight: const Radius.circular(20),
//                     bottomLeft: Radius.circular(isFromDoctor ? 20 : 4),
//                     bottomRight: Radius.circular(isFromDoctor ? 4 : 20),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   message.message,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400,
//                     color: isFromDoctor ? Colors.white : const Color(0xFF1A1A1A),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 _formatMessageTime(message.time),
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.grey[500],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimestampDivider(String time) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         children: [
//           Expanded(child: Divider(color: Colors.grey[300])),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 _formatTimestamp(time),
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(child: Divider(color: Colors.grey[300])),
//         ],
//       ),
//     );
//   }

//   String _formatTimestamp(String timestamp) {
//     try {
//       final date = DateTime.parse(timestamp);
//       final now = DateTime.now();
//       final difference = now.difference(date);
      
//       if (difference.inDays == 0) {
//         return 'Today';
//       } else if (difference.inDays == 1) {
//         return 'Yesterday';
//       } else {
//         return '${date.day}/${date.month}/${date.year}';
//       }
//     } catch (e) {
//       return 'Unknown';
//     }
//   }

//   String _formatMessageTime(String timestamp) {
//     try {
//       final date = DateTime.parse(timestamp);
//       final hour = date.hour.toString().padLeft(2, '0');
//       final minute = date.minute.toString().padLeft(2, '0');
//       return '$hour:$minute';
//     } catch (e) {
//       return 'Pending...';
//     }
//   }

//   Widget _buildMessageInput(MessageViewModel viewModel, String doctorId) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               height: 44,
//               width: 44,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5F7FA),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   // Add attachment functionality
//                 },
//                 icon: const Icon(
//                   Icons.attach_file,
//                   color: Color(0xFF6B7280),
//                   size: 20,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Container(
//                 constraints: const BoxConstraints(maxHeight: 120),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF8FAFE),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: const Color(0xFFE8ECF4)),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   focusNode: _textFieldFocus,
//                   maxLines: null,
//                   textInputAction: TextInputAction.newline,
//                   decoration: const InputDecoration(
//                     hintText: 'Type your message...',
//                     hintStyle: TextStyle(
//                       color: Color(0xFF9CA3AF),
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   ),
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Container(
//               height: 44,
//               width: 44,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF667EEA).withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 onPressed: () => _sendMessage(viewModel, doctorId),
//                 icon: const Icon(
//                   Icons.send_rounded,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _sendMessage(MessageViewModel viewModel, String doctorId) async {
//     if (_messageController.text.trim().isEmpty) return;

//     final chatsSnapshot = await _db
//         .collection('chats')
//         .where('participants', arrayContains: widget.patientId)
//         .limit(1)
//         .get();
    
//     print('Chat query result for ${widget.patientId}: ${chatsSnapshot.docs.map((d) => d.data())}');

//     if (_messageController.text.isNotEmpty) {
//       final chatId = _getChatId(doctorId, widget.patientId);
//       if (chatsSnapshot.docs.isEmpty) {
//         await _db.collection('chats').doc(chatId).set({
//           'participants': [doctorId, widget.patientId],
//           'lastMessage': '',
//           'timestamp': FieldValue.serverTimestamp(),
//           'unreadCount': 0
//         });
//       }
      
//       viewModel.sendMessage(widget.patientId, _messageController.text);
//       _messageController.clear();
      
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   String _getChatId(String doctorId, String patientId) {
//     return doctorId.compareTo(patientId) < 0
//         ? '$doctorId-$patientId'
//         : '$patientId-$doctorId';
//   }
// }















import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _textFieldFocus = FocusNode();
  DateTime? _lastDisplayedDate; // Track the last date a timestamp was shown

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = MessageViewModel(BlocProvider.of<MessageBloc>(context));
    final doctorId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesStream(doctorId),
          ),
          _buildMessageInput(viewModel, doctorId),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF6B7280),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Row(
        children: [
          _buildPatientAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                // Text(
                //   'Online now',
                //   style: TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.w400,
                //     color: Colors.grey[600],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: _buildCallButton(context),
        ),
        // Container(
        //   margin: const EdgeInsets.only(right: 16),
        //   child: _buildMoreButton(context),
        // ),
      ],
    );
  }

  Widget _buildPatientAvatar() {
    final initials = _getInitials(widget.patientName);
    
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: initials.isNotEmpty
          ? Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1 && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }

  Widget _buildCallButton(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {
          // Add call functionality
        },
        icon: const Icon(
          Icons.call,
          color: Color(0xFF10B981),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
      ),
      child: IconButton(
        onPressed: () {
          // Add more options functionality
        },
        icon: const Icon(
          Icons.more_vert,
          color: Color(0xFF6B7280),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMessagesStream(String doctorId) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFE),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('chats')
            .doc(_getChatId(doctorId, widget.patientId))
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildLoadingState();
          }

             final messages = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final timestamp = data['timestamp'] as Timestamp?;
            final senderId = data['senderId'] as String;
            final isDoctor = senderId == doctorId;
            final senderName = isDoctor ? 'You' : widget.patientName;
            final time = (timestamp != null? timestamp.toDate().toLocal(): DateTime.now().toLocal()).toIso8601String();
            final messageContent = data['message'] ?? 'No message content';
            return MessageModel(
              senderName: senderName,
              time: time,
              messageCount: 1,
              patientId: widget.patientId,
              message: messageContent,
            );
          }).toList();

          print('Total messages fetched: ${messages.length}');

          if (messages.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            controller: _scrollController,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final showTimestamp = _shouldShowTimestamp(messages, index);
              return _buildMessageBubble(message, doctorId, showTimestamp);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Color(0xFF667EEA),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start the conversation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to ${widget.patientName}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(List<MessageModel> messages, int index) {
    final currentDate = _tryParseLocal(messages[index].time);
    if(currentDate == null) return false;

    if(index == 0) return true;
    final prevDate = _tryParseLocal(messages[index - 1].time);
    if(prevDate == null) return true;

    return !_isSameDay(currentDate, prevDate);
  }

  DateTime? _tryParseLocal(String time) {
    try{
      final dt = DateTime.parse(time);
      return dt.isUtc ? dt.toLocal() : dt;
    }catch(_){
      return null;
    }
  }

  bool _isSameDay(DateTime a, DateTime b){
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildMessageBubble(MessageModel message, String doctorId, bool showTimestamp) {
    final isFromDoctor = message.senderName == 'You';
    
    return Column(
      crossAxisAlignment: isFromDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showTimestamp) _buildTimestampDivider(message.time),
        Container(
          margin: EdgeInsets.only(
            bottom: 8,
            left: isFromDoctor ? 60 : 0,
            right: isFromDoctor ? 0 : 60,
          ),
          child: Column(
            crossAxisAlignment: isFromDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isFromDoctor
                      ? const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        )
                      : null,
                  color: isFromDoctor ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isFromDoctor ? 20 : 4),
                    bottomRight: Radius.circular(isFromDoctor ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: isFromDoctor ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatMessageTime(message.time),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimestampDivider(String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatTimestamp(time),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = _tryParseLocal(timestamp);
      if(date == null) return 'Unknown';

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final msgDay = DateTime(date.year, date.month, date.day);
      final yesterday = today.subtract(const Duration(days: 1));

      if(_isSameDay(msgDay, today)){
        return 'Today';
      }else if(_isSameDay(msgDay, yesterday)){
        return 'Yesterday';
      }else{
        return '${date.day}/${date.month}/${date.year}';
      }
    }catch(_){
      return 'Unknown';
    }
  }

  String _formatMessageTime(String timestamp) {
    try {
      final date = _tryParseLocal(timestamp);
      if(date == null) return 'Pending...';
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return 'Pending...';
    }
  }

  Widget _buildMessageInput(MessageViewModel viewModel, String doctorId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  // Add attachment functionality
                },
                icon: const Icon(
                  Icons.attach_file,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFE),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8ECF4)),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _textFieldFocus,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _sendMessage(viewModel, doctorId),
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(MessageViewModel viewModel, String doctorId) async {
    if (_messageController.text.trim().isEmpty) return;

    final chatsSnapshot = await _db
        .collection('chats')
        .where('participants', arrayContains: widget.patientId)
        .limit(1)
        .get();
    
    print('Chat query result for ${widget.patientId}: ${chatsSnapshot.docs.map((d) => d.data())}');

    if (_messageController.text.isNotEmpty) {
      final chatId = _getChatId(doctorId, widget.patientId);
      if (chatsSnapshot.docs.isEmpty) {
        await _db.collection('chats').doc(chatId).set({
          'participants': [doctorId, widget.patientId],
          'lastMessage': '',
          'timestamp': FieldValue.serverTimestamp(),
          'unreadCount': 0
        });
      }
      
      viewModel.sendMessage(widget.patientId, _messageController.text);
      _messageController.clear();
      
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _getChatId(String doctorId, String patientId) {
    return doctorId.compareTo(patientId) < 0
        ? '$doctorId-$patientId'
        : '$patientId-$doctorId';
  }
  
}