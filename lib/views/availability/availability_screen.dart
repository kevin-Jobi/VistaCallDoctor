import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
import 'package:vista_call_doctor/view_models/availability_view_model.dart';
import 'availability_ui.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final availabilityBloc = BlocProvider.of<AvailabilityBloc>(context);
      final viewModel = AvailabilityViewModel(availabilityBloc);
      final formKey = GlobalKey<FormState>();

      return BlocBuilder<AvailabilityBloc, AvailabilityState>(
        builder: (context, state) {
          return AvailabilityUI(
            formKey: formKey,
            viewModel: viewModel,
            state: state,
          );
        },
      );
    } catch (e) {
      print('Error in AvailabilityScreen build: $e');
      return const Scaffold(body: Center(child: Text('Error loading screen')));
    }
  }
}