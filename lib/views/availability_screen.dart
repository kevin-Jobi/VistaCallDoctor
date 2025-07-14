// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';
// import '../blocs/availability/availability_bloc.dart';
// import '../blocs/availability/availability_state.dart';
// import '../view_models/availability_view_model.dart';
// import 'certificate_screen.dart';

// class AvailabilityScreen extends StatelessWidget {
//   const AvailabilityScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     try {
//       final availabilityBloc = BlocProvider.of<AvailabilityBloc>(context);
//       final viewModel = AvailabilityViewModel(availabilityBloc);
//       final formKey = GlobalKey<FormState>(); // Form key for validation

//       return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//         appBar: AppBar(
//           title: const Text('Select your Available days'),
//           backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: formKey,
//             child: BlocBuilder<AvailabilityBloc, AvailabilityState>(
//               builder: (context, state) {
//                 print('AvailabilityState: $state'); // Debug state
//                 if (state.isSubmitting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 // Fallback if state is unexpected
//                 if (state.availability.availableDays.isEmpty &&
//                     state.availability.yearsOfExperience.isEmpty &&
//                     state.availability.fees.isEmpty) {
//                   return const Center(
//                     child: Text('Loading or initializing...'),
//                   );
//                 }
//                 return SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 30),
//                       Container(
//                         alignment: Alignment.center,
//                         child: Wrap(
//                           spacing: 10,
//                           runSpacing: 16,
//                           alignment: WrapAlignment.center,
//                           children:
//                               [
//                                 'Mon',
//                                 'Tue',
//                                 'Wed',
//                                 'Thu',
//                                 'Fri',
//                                 'Sat',
//                                 'Sun',
//                               ].map((day) {
//                                 final isSelected = state
//                                     .availability
//                                     .availableDays
//                                     .contains(day);
//                                 return ChoiceChip(
//                                   label: Text(
//                                     day,
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                   labelPadding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 8,
//                                   ),
//                                   selected: isSelected,
//                                   selectedColor: const Color.fromARGB(
//                                     255,
//                                     84,
//                                     178,
//                                     255,
//                                   ),
//                                   backgroundColor: const Color.fromARGB(
//                                     255,
//                                     229,
//                                     229,
//                                     229,
//                                   ),
//                                   onSelected: (selected) {
//                                     viewModel.toggleDay(day);
//                                   },
//                                 );
//                               }).toList(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         labelText: 'Years Of Experience',
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your years of experience';
//                           }
//                           final years = int.tryParse(value);
//                           if (years == null || years < 0) {
//                             return 'Please enter a valid number of years';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) =>
//                             viewModel.updateYearsOfExperience(value),
//                       ),
//                       const SizedBox(height: 15),
//                       CustomTextField(
//                         labelText: 'Your Fees (₹)',
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your fees';
//                           }
//                           final fees = int.tryParse(value);
//                           if (fees == null || fees <= 0) {
//                             return 'Please enter a valid positive fee amount';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) => viewModel.updateFees(value),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ), // Replaced Spacer with padding
//                       ElevatedButton(
//                         onPressed: () {
//                           final isValid =
//                               formKey.currentState?.validate() ?? false;
//                           print('Form validation result: $isValid');
//                           print(
//                             'Available days: ${state.availability.availableDays}',
//                           );
//                           print(
//                             'Years of Experience: ${state.availability.yearsOfExperience}',
//                           );
//                           print('Fees: ${state.availability.fees}');
//                           if (isValid &&
//                               state.availability.availableDays.isNotEmpty) {
//                             viewModel.submitAvailability();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const CertificateScreen(),
//                               ),
//                             );
//                           } else if (!state
//                               .availability
//                               .availableDays
//                               .isNotEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Please select at least one day'),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Please fill all fields correctly',
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 50,
//                             vertical: 15,
//                           ),
//                         ),
//                         child: const Text('Continue'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       );
//     } catch (e) {
//       print('Error in AvailabilityScreen build: $e');
//       return const Scaffold(body: Center(child: Text('Error loading screen')));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';
import '../blocs/availability/availability_bloc.dart';
import '../blocs/availability/availability_state.dart';
import '../view_models/availability_view_model.dart';
import 'certificate_screen.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final availabilityBloc = BlocProvider.of<AvailabilityBloc>(context);
      final viewModel = AvailabilityViewModel(availabilityBloc);
      final formKey = GlobalKey<FormState>(); // Form key for validation

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 247, 255),
        appBar: AppBar(
          title: const Text('Select your Available days'),
          backgroundColor: const Color.fromARGB(255, 237, 247, 255),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: BlocBuilder<AvailabilityBloc, AvailabilityState>(
              builder: (context, state) {
                print('AvailabilityState: $state'); // Debug state
                if (state.isSubmitting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Only show loading if submitting or no data is expected yet
                // if (state.isSubmitting ||
                //     (state.availability.availableDays.isEmpty &&
                //         state.availability.yearsOfExperience.isEmpty &&
                //         state.availability.fees.isEmpty &&
                //         !state.isSuccess)) {
                //   return const Center(
                //     child: Text('Loading or initializing...'),
                //   );
                // }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children:
                              [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ].map((day) {
                                final isSelected = state
                                    .availability
                                    .availableDays
                                    .contains(day);
                                return ChoiceChip(
                                  label: Text(
                                    day,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  selected: isSelected,
                                  selectedColor: const Color.fromARGB(
                                    255,
                                    84,
                                    178,
                                    255,
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    229,
                                    229,
                                    229,
                                  ),
                                  onSelected: (selected) {
                                    viewModel.toggleDay(day);
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'Years Of Experience',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your years of experience';
                          }
                          final years = int.tryParse(value);
                          if (years == null || years < 0) {
                            return 'Please enter a valid number of years';
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            viewModel.updateYearsOfExperience(value),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        labelText: 'Your Fees (₹)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your fees';
                          }
                          final fees = int.tryParse(value);
                          if (fees == null || fees <= 0) {
                            return 'Please enter a valid positive fee amount';
                          }
                          return null;
                        },
                        onChanged: (value) => viewModel.updateFees(value),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          final isValid =
                              formKey.currentState?.validate() ?? false;
                          print('Form validation result: $isValid');
                          print(
                            'Available days: ${state.availability.availableDays}',
                          );
                          print(
                            'Years of Experience: ${state.availability.yearsOfExperience}',
                          );
                          print('Fees: ${state.availability.fees}');
                          if (isValid &&
                              state.availability.availableDays.isNotEmpty) {
                            viewModel.submitAvailability();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CertificateScreen(),
                              ),
                            );
                          } else if (!state
                              .availability
                              .availableDays
                              .isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select at least one day'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill all fields correctly',
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
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error in AvailabilityScreen build: $e');
      return const Scaffold(body: Center(child: Text('Error loading screen')));
    }
  }
}
