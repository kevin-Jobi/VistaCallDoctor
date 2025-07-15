import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_bloc.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_event.dart';
import 'package:vista_call_doctor/blocs/onboarding/onboarding_state.dart';
import 'package:vista_call_doctor/blocs/profile/profile_bloc.dart';
import 'package:vista_call_doctor/views/welcome_screen.dart';
import '../blocs/certificate/certificate_bloc.dart';
import '../blocs/certificate/certificate_state.dart';
import '../view_models/certificate_view_model.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  _showSubmissionSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          'Data is submitted. You can login once the admin approves your account.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final certificateBloc = BlocProvider.of<CertificateBloc>(context);
    final viewModel = CertificateViewModel(certificateBloc);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 165, 197),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 165, 197),
        title: const Text(
          'Add Your Certificate',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: MultiBlocListener(
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

                // Navigator.pop(context); // Or navigate to next screen
              }
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
          ),
          BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingSuccess) {
                _showSubmissionSuccessDialog(context);
              }
              if (state is OnboardingFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CertificateBloc, CertificateState>(
            builder: (context, state) {
              if (state.isSubmitting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final pickedFile = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  viewModel.uploadCertificate(pickedFile.path);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      13,
                                      130,
                                      225,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 60,
                                      color: Color.fromARGB(255, 13, 130, 225),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Camera',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          13,
                                          130,
                                          225,
                                        ),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () async {
                                final pickedFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  viewModel.uploadCertificate(pickedFile.path);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      13,
                                      130,
                                      225,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.photo_library,
                                      size: 60,
                                      color: Color.fromARGB(255, 13, 130, 225),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Gallery',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          13,
                                          130,
                                          225,
                                        ),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (state.certificatePath != null &&
                            state.certificatePath!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Certificate selected: ${state.certificatePath}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  ElevatedButton(
                    onPressed: () async {
                      if (state.certificatePath != null) {
                        final onboardingBloc = context.read<OnboardingBloc>();
                        final profileState = context.read<ProfileBloc>().state;
                        final availabilityState = context
                            .read<AvailabilityBloc>()
                            .state;

                        onboardingBloc.add(
                          SubmitOnboarding(
                            fullName: profileState.profile.fullName,
                            age: profileState.profile.age,
                            dateOfBirth: profileState.profile.dateOfBirth,
                            email: profileState.profile.email,
                            password: profileState.profile.password,
                            gender: profileState.profile.gender,
                            department: profileState.profile.department,
                            hospitalName: profileState.profile.hospitalName,
                            profileImage: profileState.profile.profileImage,
                            availableDays:
                                availabilityState.availability.availableDays,
                            yearsOfExperience: availabilityState
                                .availability
                                .yearsOfExperience,
                            fees: availabilityState.availability.fees,
                            certificatePath: state.certificatePath!,
                          ),
                        );

                        // Listen for completion
                        await showDialog(
                          context: context,
                          builder: (_) =>
                              BlocListener<OnboardingBloc, OnboardingState>(
                                listener: (context, state) {
                                  if (state is OnboardingSuccess) {
                                    Navigator.pop(context);
                                    _showSuccessDialog(
                                      context,
                                      profileState.profile.email,
                                    );
                                  }
                                  if (state is OnboardingFailure) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.error)),
                                    );
                                  }
                                },
                                child: const AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 20),
                                      Text('Submitting your information...'),
                                    ],
                                  ),
                                ),
                              ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('Complete Registration'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void _showSuccessDialog(BuildContext context, String email) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Registration Complete'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your account is pending admin approval.'),
          const Text('You will receive an email when approved.'),
          const SizedBox(height: 20),
          Text('Reference Email: $email'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
