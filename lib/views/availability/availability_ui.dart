// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
// import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
// import 'package:vista_call_doctor/view_models/availability_view_model.dart';
// import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';

// class AvailabilityUI extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   final AvailabilityViewModel viewModel;
//   final AvailabilityState state;

//   const AvailabilityUI({
//     super.key,
//     required this.formKey,
//     required this.viewModel,
//     required this.state,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 79, 145, 175),
//       appBar: AppBar(
//         title: const Text('Select your Available days'),
//         backgroundColor: const Color.fromARGB(255, 79, 145, 175),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(key: formKey, child: _buildContent(context)),
//       ),
//     );
//   }

//   Widget _buildContent(BuildContext context) {
//     if (state.isSubmitting) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(height: 30),
//           _buildDaysSelection(context),
//           const SizedBox(height: 20),
//           _buildYearsOfExperienceField(),
//           const SizedBox(height: 15),
//           _buildFeesField(),
//           const SizedBox(height: 20),
//           _buildContinueButton(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildDaysSelection(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       child: Wrap(
//         spacing: 10,
//         runSpacing: 16,
//         alignment: WrapAlignment.center,
//         children: [
//           'Mon',
//           'Tue',
//           'Wed',
//           'Thu',
//           'Fri',
//           'Sat',
//           'Sun',
//         ].map((day) => _buildDayChip(context, day)).toList(),
//       ),
//     );
//   }

//   Widget _buildDayChip(BuildContext context, String day) {
//     return BlocBuilder<AvailabilityBloc, AvailabilityState>(
//       builder: (context, state) {
//         final isSelected = state.availability.availableDays.contains(day);
//         return ChoiceChip(
//           label: Text(
//             day,
//             style: TextStyle(
//               fontSize: 18,
//               color: isSelected ? Colors.white : Colors.black,
//             ),
//           ),
//           labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           selected: isSelected,
//           selectedColor: const Color.fromARGB(255, 84, 178, 255),
//           backgroundColor: const Color.fromARGB(255, 229, 229, 229),
//           onSelected: (_) {
//             viewModel.toggleDay(day);
//             if (isSelected) {
//               _showTimeSlotsDialog(context, day);
//             }
//           },
//         );
//       },
//     );
//   }

//   Widget _buildYearsOfExperienceField() {
//     return CustomTextField(
//       labelText: 'Years Of Experience',
//       keyboardType: TextInputType.number,
//       validator: viewModel.validateYearsOfExperience,
//       onChanged: viewModel.updateYearsOfExperience,
//     );
//   }

//   Widget _buildFeesField() {
//     return CustomTextField(
//       labelText: 'Your Fees (₹)',
//       keyboardType: TextInputType.number,
//       validator: viewModel.validateFees,
//       onChanged: viewModel.updateFees,
//     );
//   }

//   Widget _buildContinueButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => _handleContinuePressed(context),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//       ),
//       child: const Text('Continue'),
//     );
//   }

//   void _showTimeSlotsDialog(BuildContext context, String day) {
//     final List<String> possibleSlots = [
//       '08:00-09:00',
//       '09:00-10:00',
//       '10:00-11:00',
//       '11:00-12:00',
//       '12:00-13:00',
//       '13:00-14:00',
//       '14:00-15:00',
//       '15:00-16:00',
//       '16:00-17:00',
//       '17:00-18:00',
//       '18:00-19:00',
//       '19:00-20:00',
//       '20:00-21:00',
//     ];
//     List<String> selectedSlots = List.from(state.availability.availableTimeSlots[day] ?? []);

//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text('Select time slot for $day'),
//           content: StatefulBuilder(
//             builder: (BuildContext innerContext, StateSetter setState) {
//               return SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: possibleSlots.map((slot) {
//                     return CheckboxListTile(
//                       title: Text(slot),
//                       value: selectedSlots.contains(slot),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value == true) {
//                             if (!selectedSlots.contains(slot)) {
//                               selectedSlots.add(slot);
//                             }
//                           } else {
//                             selectedSlots.remove(slot);
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 viewModel.updateDaySlots(day, selectedSlots);
//                 Navigator.of(dialogContext).pop();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _handleContinuePressed(BuildContext context) {
//     final isValid = formKey.currentState?.validate() ?? false;

//     if (!isValid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields correctly')),
//       );
//       return;
//     }

//     if (state.availability.availableDays.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select at least one day')),
//       );
//       return;
//     }

//     for (var day in state.availability.availableDays) {
//       if ((state.availability.availableTimeSlots[day] ?? []).isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select at least one time slot for each available day')),
//         );
//         return;
//       }
//     }

//     viewModel.submitAvailability();
//     viewModel.navigateToCertificateScreen(context);
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_bloc.dart';
import 'package:vista_call_doctor/blocs/availability/availability_state.dart';
import 'package:vista_call_doctor/view_models/availability_view_model.dart';
import 'package:vista_call_doctor/views/widgets/custom_textfield.dart';

class AvailabilityUI extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AvailabilityViewModel viewModel;
  final AvailabilityState state;

  const AvailabilityUI({
    super.key,
    required this.formKey,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F91AF),
      body: SafeArea(
        child: Column(
          children: [
            _buildModernAppBar(context),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: Form(
                    key: formKey,
                    child: _buildContent(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Availability',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Choose your working days & hours',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (state.isSubmitting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF4F91AF),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Saving your availability...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle('Available Days'),
          const SizedBox(height: 16),
          _buildDaysSelection(context),
          
          // Show selected days and time slots
          _buildSelectedDaysAndSlots(context),
          
          const SizedBox(height: 32),
          _buildSectionTitle('Professional Details'),
          const SizedBox(height: 16),
          _buildYearsOfExperienceField(),
          const SizedBox(height: 20),
          _buildFeesField(),
          const SizedBox(height: 40),
          _buildContinueButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildDaysSelection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ].map((day) => _buildModernDayChip(context, day)).toList(),
      ),
    );
  }

  Widget _buildSelectedDaysAndSlots(BuildContext context) {
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
      builder: (context, state) {
        final selectedDays = state.availability.availableDays;
        
        if (selectedDays.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildSectionTitle('Selected Schedule'),
            const SizedBox(height: 16),
            ...selectedDays.map((day) => _buildSelectedDayCard(context, day)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildSelectedDayCard(BuildContext context, String day) {
    final timeSlots = state.availability.availableTimeSlots[day] ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4F91AF).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F91AF).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F91AF), Color(0xFF54B2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _getFullDayName(day),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showModernTimeSlotsDialog(context, day),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Time slots
          Padding(
            padding: const EdgeInsets.all(16),
            child: timeSlots.isEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No time slots selected. Tap edit to add.',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: timeSlots.map((slot) => _buildTimeSlotChip(slot)).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotChip(String timeSlot) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4F91AF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4F91AF).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        timeSlot,
        style: const TextStyle(
          color: Color(0xFF4F91AF),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getFullDayName(String shortDay) {
    const Map<String, String> dayNames = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };
    return dayNames[shortDay] ?? shortDay;
  }

  Widget _buildModernDayChip(BuildContext context, String day) {
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
      builder: (context, state) {
        final isSelected = state.availability.availableDays.contains(day);
        final hasTimeSlots = (state.availability.availableTimeSlots[day] ?? []).isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: InkWell(
            onTap: () {
              if (isSelected) {
                // If day is already selected, show time slots dialog
                _showModernTimeSlotsDialog(context, day);
              } else {
                // If day is not selected, select it first then show dialog
                viewModel.toggleDay(day);
                Future.delayed(const Duration(milliseconds: 100), () {
                  _showModernTimeSlotsDialog(context, day);
                });
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF4F91AF), Color(0xFF54B2FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4F91AF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF4A5568),
                    ),
                  ),
                  if (isSelected && hasTimeSlots) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearsOfExperienceField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomTextField(
        labelText: 'Years Of Experience',
        keyboardType: TextInputType.number,
        validator: viewModel.validateYearsOfExperience,
        onChanged: viewModel.updateYearsOfExperience,
      ),
    );
  }

  Widget _buildFeesField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomTextField(
        labelText: 'Your Fees (₹)',
        keyboardType: TextInputType.number,
        validator: viewModel.validateFees,
        onChanged: viewModel.updateFees,
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F91AF), Color(0xFF54B2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F91AF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _handleContinuePressed(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showModernTimeSlotsDialog(BuildContext context, String day) {
    final List<String> possibleSlots = [
      '08:00-09:00',
      '09:00-10:00',
      '10:00-11:00',
      '11:00-12:00',
      '12:00-13:00',
      '13:00-14:00',
      '14:00-15:00',
      '15:00-16:00',
      '16:00-17:00',
      '17:00-18:00',
      '18:00-19:00',
      '19:00-20:00',
      '20:00-21:00',
    ];
    List<String> selectedSlots = List.from(state.availability.availableTimeSlots[day] ?? []);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4F91AF), Color(0xFF54B2FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Select time slots for ${_getFullDayName(day)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: StatefulBuilder(
                    builder: (BuildContext innerContext, StateSetter setState) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: possibleSlots.map((slot) {
                            final isSelected = selectedSlots.contains(slot);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF4F91AF).withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF4F91AF) : const Color(0xFFE2E8F0),
                                  width: 1.5,
                                ),
                              ),
                              child: CheckboxListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                title: Text(
                                  slot,
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF4F91AF) : const Color(0xFF4A5568),
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                                value: isSelected,
                                activeColor: const Color(0xFF4F91AF),
                                checkColor: Colors.white,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      if (!selectedSlots.contains(slot)) {
                                        selectedSlots.add(slot);
                                      }
                                    } else {
                                      selectedSlots.remove(slot);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
                // Actions
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF4A5568),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.updateDaySlots(day, selectedSlots);
                            Navigator.of(dialogContext).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F91AF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleContinuePressed(BuildContext context) {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      _showModernSnackBar(
        context,
        'Please fill all fields correctly',
        Icons.warning_amber_rounded,
        Colors.orange,
      );
      return;
    }

    if (state.availability.availableDays.isEmpty) {
      _showModernSnackBar(
        context,
        'Please select at least one day',
        Icons.calendar_today,
        Colors.red,
      );
      return;
    }

    for (var day in state.availability.availableDays) {
      if ((state.availability.availableTimeSlots[day] ?? []).isEmpty) {
        _showModernSnackBar(
          context,
          'Please select at least one time slot for each available day',
          Icons.access_time,
          Colors.red,
        );
        return;
      }
    }

    viewModel.submitAvailability();
    viewModel.navigateToCertificateScreen(context);
  }

  void _showModernSnackBar(BuildContext context, String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}