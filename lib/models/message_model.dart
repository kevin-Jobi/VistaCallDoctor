class MessageModel {
  final String senderName;
  final String time;
  final int messageCount;
  final String patientId;
  final String message;
  final String chatId;

  MessageModel({
    required this.senderName,
    required this.time,
    required this.messageCount,
    required this.patientId,
    required this.message,
    required this.chatId
  });
}