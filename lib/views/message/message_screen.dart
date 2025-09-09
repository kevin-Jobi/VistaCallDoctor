// // views/message/message_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/message/message_bloc.dart';
// import 'package:vista_call_doctor/blocs/message/message_state.dart';
// import 'package:vista_call_doctor/navigation/bottom_navigation.dart';
// import 'package:vista_call_doctor/view_models/message_view_model.dart';
// import 'message_ui.dart';

// class MessageScreen extends StatelessWidget {
//   const MessageScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final messageBloc = BlocProvider.of<MessageBloc>(context);
//     final viewModel = MessageViewModel(messageBloc);

//     viewModel.loadMessages();

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//       appBar: _buildAppBar(),
//       body: _buildBody(viewModel),
//       bottomNavigationBar: const BottomNavigation(currentIndex: 1),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//       title: const Text('Messages'),
//     );
//   }

//   Widget _buildBody(MessageViewModel viewModel) {
//     return BlocBuilder<MessageBloc, MessageState>(
//       builder: (context, state) {
//         return MessageUI(state: state);
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: _buildAppBar(context),
      body: _buildBody(viewModel),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            'Stay connected with your patients',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: _buildSearchButton(context),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: _buildNewMessageButton(context),
        ),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
      ),
      child: IconButton(
        onPressed: () {
          // Add search functionality here if needed
        },
        icon: const Icon(
          Icons.search_outlined,
          color: Color(0xFF6B7280),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildNewMessageButton(BuildContext context) {
    return Container(
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
        onPressed: () {
          // Add new message functionality here if needed
        },
        icon: const Icon(
          Icons.edit_outlined,
          color: Colors.white,
          size: 22,
        ),
      ),
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