

// 6-10-2024: Refactored to allow optional external bloc for reuse (e.g., from ProfileScreen)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
import 'package:vista_call_doctor/view_models/availability_view_model.dart';
import 'availability_ui.dart';

class AvailabilityScreen extends StatelessWidget {
  final bool isFromProfile;
  final AvailabilityBloc? bloc; // optional external bloc

  const AvailabilityScreen({super.key, this.isFromProfile = false, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      // ✅ Reuse provided bloc (from ProfileScreen) to avoid creating a new one
      return BlocProvider.value(
        value: bloc!,
        child: _AvailabilityScreenBody(isFromProfile: isFromProfile),
      );
    }

    // ✅ Otherwise create a new instance
    return BlocProvider(
      create: (_) => AvailabilityBloc(),
      child: _AvailabilityScreenBody(isFromProfile: isFromProfile),
    );
  }
}

class _AvailabilityScreenBody extends StatefulWidget {
  final bool isFromProfile;
  const _AvailabilityScreenBody({required this.isFromProfile});

  @override
  State<_AvailabilityScreenBody> createState() => _AvailabilityScreenBodyState();
}

class _AvailabilityScreenBodyState extends State<_AvailabilityScreenBody> {
  late final AvailabilityViewModel viewModel;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    final availabilityBloc = context.read<AvailabilityBloc>();
    final authBloc = context.read<AuthBloc>();
    viewModel = AvailabilityViewModel(availabilityBloc, authBloc);
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
      builder: (context, state) {
        return AvailabilityUI(
          formKey: formKey,
          viewModel: viewModel,
          state: state,
          isFromProfile: widget.isFromProfile,
        );
      },
    );
  }
}
