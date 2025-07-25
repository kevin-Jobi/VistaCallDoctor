// views/message/message_ui.dart
import 'package:flutter/material.dart';
import 'package:vista_call_doctor/blocs/message/message_state.dart';
import 'package:vista_call_doctor/models/message_model.dart';

class MessageUI extends StatelessWidget {
  final MessageState state;

  const MessageUI({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      itemCount: state.messages.length,
      itemBuilder: (context, index) => _buildMessageItem(state.messages[index]),
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        color: Colors.grey,
        indent: 5,
        endIndent: 5,
      ),
    );
  }

  Widget _buildMessageItem(MessageModel message) { // there was an error in argument
    return ListTile(
      leading: const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(message.senderName),
      subtitle: Text('${message.messageCount} messages'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message.time),
          const SizedBox(height: 5),
          const CircleAvatar(
            radius: 10,
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}