// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_event.dart';
// import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
// import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';
// import '../blocs/profile/profile_bloc.dart';
// import '../blocs/profile/profile_state.dart';
// import '../view_models/profile_view_model.dart';
// import 'availability_screen.dart';

// class ProfileFillingScreen extends StatelessWidget {
//   const ProfileFillingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final profileBloc = BlocProvider.of<ProfileBloc>(context);
//     final viewModel = ProfileViewModel(profileBloc);
//     final formKey = GlobalKey<FormState>(); // Define form key

//     // Trigger GetDepartmentEvent only if not already loaded
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authState = context.read<AuthBloc>().state;
//       if (authState is! GetDepartmentLoadedState) {
//         context.read<AuthBloc>().add(GetDepartmentEvent());
//       }
//     });

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 237, 247, 255),
//         title: const Text('Add Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: formKey, // Associate form key with Form widget
//           child: BlocBuilder<ProfileBloc, ProfileState>(
//             builder: (context, state) {
//               if (state.isSubmitting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey,
//                       child: Icon(Icons.person, size: 50, color: Colors.white),
//                     ),
//                     const SizedBox(height: 20),
//                     CustomTextField(
//                       labelText: 'Full Name',
//                       keyboardType: TextInputType.text,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your full name';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) => viewModel.updateFullName(value),
//                     ),
//                     CustomTextField(
//                       labelText: 'Age',
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your age';
//                         }
//                         final age = int.tryParse(value);
//                         if (age == null || age < 18 || age > 100) {
//                           return 'Age must be between 18 and 100';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) => viewModel.updateAge(value),
//                     ),
//                     CustomTextField(
//                       labelText: 'Date of Birth',
//                       keyboardType: TextInputType.datetime,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your date of birth';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) => viewModel.updateDateOfBirth(value),
//                     ),
//                     CustomTextField(
//                       labelText: 'Email',
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         final emailRegex = RegExp(
//                           r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                         );
//                         if (!emailRegex.hasMatch(value)) {
//                           return 'Please enter a valid email address';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) => viewModel.updateEmail(value),
//                     ),
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         hintText: 'Select Gender',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: const Color.fromARGB(255, 229, 229, 229),
//                       ),
//                       items: ['Male', 'Female', 'Other']
//                           .map(
//                             (gender) => DropdownMenuItem<String>(
//                               value: gender,
//                               child: Text(gender),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         if (value != null) viewModel.updateGender(value);
//                       },
//                       value: state.profile.gender.isNotEmpty
//                           ? state.profile.gender
//                           : null,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select a gender';
//                         }
//                         return null;
//                       },
//                       borderRadius: BorderRadius.circular(30),
//                       icon: const Icon(Icons.arrow_drop_down),
//                     ),
//                     const SizedBox(height: 15),
//                     BlocBuilder<AuthBloc, AuthState>(
//                       builder: (context, authState) {
//                         if (authState is GetDepartmentLoadingState) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         } else if (authState is GetDepartmentErrorState) {
//                           return Text('Error: ${authState.error}');
//                         } else if (authState is GetDepartmentLoadedState) {
//                           return DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               hintText: 'Select Department',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: const Color.fromARGB(
//                                 255,
//                                 229,
//                                 229,
//                                 229,
//                               ),
//                             ),
//                             items: authState.departments
//                                 .map(
//                                   (department) => DropdownMenuItem<String>(
//                                     value: department,
//                                     child: Text(department),
//                                   ),
//                                 )
//                                 .toList(),
//                             onChanged: (value) {
//                               if (value != null)
//                                 viewModel.updateDepartment(value);
//                             },
//                             value: state.profile.department.isNotEmpty
//                                 ? state.profile.department
//                                 : null,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select a department';
//                               }
//                               return null;
//                             },
//                             borderRadius: BorderRadius.circular(30),
//                             icon: const Icon(Icons.arrow_drop_down),
//                           );
//                         } else {
//                           return const SizedBox.shrink();
//                         }
//                       },
//                     ),
//                     CustomTextField(
//                       labelText: 'Hospital Name',
//                       keyboardType: TextInputType.text,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your hospital name';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) => viewModel.updateHospitalName(value),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         final isValid =
//                             formKey.currentState?.validate() ?? false;
//                         print(
//                           'Form validation result: $isValid',
//                         ); // Debug print
//                         if (isValid) {
//                           // viewModel.submitProfile();
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const AvailabilityScreen(),
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 50,
//                           vertical: 15,
//                         ),
//                       ),
//                       child: const Text('Continue'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_event.dart';
import 'package:vista_call_doctor/blocs/auth/auth_state.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_state.dart';
import '../view_models/profile_view_model.dart';
import 'availability_screen.dart';

class ProfileFillingScreen extends StatelessWidget {
  const ProfileFillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final viewModel = ProfileViewModel(profileBloc);
    final formKey = GlobalKey<FormState>(); // Added form key

    // Trigger department load based on state type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! GetDepartmentLoadedState) {
        context.read<AuthBloc>().add(GetDepartmentEvent());
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 247, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 247, 255),
        title: const Text('Add Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey, // Added form key
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.isSubmitting) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      labelText: 'Full Name',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      onChanged: (value) => viewModel.updateFullName(value),
                    ),
                    CustomTextField(
                      labelText: 'Age',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 18 || age > 100) {
                          return 'Age must be between 18 and 100';
                        }
                        return null;
                      },
                      onChanged: (value) => viewModel.updateAge(value),
                    ),
                    CustomTextField(
                      labelText: 'Date of Birth',
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                      onChanged: (value) => viewModel.updateDateOfBirth(value),
                    ),
                    CustomTextField(
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onChanged: (value) => viewModel.updateEmail(value),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 229, 229),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map(
                            (gender) => DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) viewModel.updateGender(value);
                      },
                      value: state.profile.gender.isNotEmpty
                          ? state.profile.gender
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        }
                        return null;
                      },
                      borderRadius: BorderRadius.circular(30),
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        if (authState is GetDepartmentLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (authState is GetDepartmentErrorState) {
                          return Text('Error: ${authState.error}');
                        } else if (authState is GetDepartmentLoadedState) {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Select Department',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(
                                255,
                                229,
                                229,
                                229,
                              ),
                            ),
                            items: authState.departments
                                .map(
                                  (department) => DropdownMenuItem<String>(
                                    value: department,
                                    child: Text(department),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null)
                                viewModel.updateDepartment(value);
                            },
                            value: state.profile.department.isNotEmpty
                                ? state.profile.department
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a department';
                              }
                              return null;
                            },
                            borderRadius: BorderRadius.circular(30),
                            icon: const Icon(Icons.arrow_drop_down),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    CustomTextField(
                      labelText: 'Hospital Name',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your hospital name';
                        }
                        return null;
                      },
                      onChanged: (value) => viewModel.updateHospitalName(value),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          // viewModel.submitProfile();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<AvailabilityBloc>(
                                  context,
                                ),
                                child: const AvailabilityScreen(),
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
  }
}
