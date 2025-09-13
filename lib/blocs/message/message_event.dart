import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessageEvent {
  const LoadMessages();
}

class SendMessage extends MessageEvent{
  final String patientId;
  final String message;

  const SendMessage(this.patientId, this.message);

  @override
  List<Object> get props => [patientId,message];
}