import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_bloc.dart';
import 'package:vista_call_doctor/blocs/certificate/certificate_state.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_bloc.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_state.dart';
import 'package:vista_call_doctor/blocs/profile/profile_bloc.dart';
import 'package:vista_call_doctor/view_models/certificate_view_model.dart';
import 'certificate_ui.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final certificateBloc = BlocProvider.of<CertificateBloc>(context);
    final onboardingBloc = BlocProvider.of<OnboardingBloc>(context);
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final availabilityBloc = BlocProvider.of<AvailabilityBloc>(context);

    final viewModel = CertificateViewModel(
      certificateBloc,
      onboardingBloc,
      profileBloc,
      availabilityBloc,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<CertificateBloc, CertificateState>(
          listener: (context, state) {
            if (state.uploadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Certificate uploaded successfully!'),
                ),
              );
            }
            if (state.submissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Certificate submitted for verification!'),
                ),
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
        ),
        BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingSuccess) {
              viewModel.showSuccessDialog(context );
            }
            if (state is OnboardingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<CertificateBloc, CertificateState>(
        builder: (context, state) {
          return CertificateUI(
            viewModel: viewModel,
            state: state,
          );
        },
      ),
    );
  }
}