// views/message/message_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/message/message_bloc.dart';
import 'package:vista_call_doctor/blocs/message/message_state.dart';
import 'package:vista_call_doctor/navigation/bottom_navigation.dart';
import 'package:vista_call_doctor/view_models/message_view_model.dart';
import 'message_ui.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messageBloc = BlocProvider.of<MessageBloc>(context);
    final viewModel = MessageViewModel(messageBloc);

    viewModel.loadMessages();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 247, 255),
      appBar: _buildAppBar(),
      body: _buildBody(viewModel),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 237, 247, 255),
      title: const Text('Messages'),
    );
  }

  Widget _buildBody(MessageViewModel viewModel) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        return MessageUI(state: state);
      },
    );
  }
}