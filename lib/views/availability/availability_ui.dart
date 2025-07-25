// views/availability/availability_ui.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      backgroundColor: const Color.fromARGB(255, 79, 145, 175),
      appBar: AppBar(
        title: const Text('Select your Available days'),
        backgroundColor: const Color.fromARGB(255, 79, 145, 175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (state.isSubmitting) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          _buildDaysSelection(),
          const SizedBox(height: 20),
          _buildYearsOfExperienceField(),
          const SizedBox(height: 15),
          _buildFeesField(),
          const SizedBox(height: 20),
          _buildContinueButton(context),
        ],
      ),
    );
  }

  Widget _buildDaysSelection() {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        spacing: 10,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
            .map((day) => _buildDayChip(day))
            .toList(),
      ),
    );
  }

  Widget _buildDayChip(String day) {
    final isSelected = state.availability.availableDays.contains(day);
    return ChoiceChip(
      label: Text(
        day,
        style: TextStyle(
          fontSize: 18,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      selected: isSelected,
      selectedColor: const Color.fromARGB(255, 84, 178, 255),
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      onSelected: (_) => viewModel.toggleDay(day),
    );
  }

  Widget _buildYearsOfExperienceField() {
    return CustomTextField(
      labelText: 'Years Of Experience',
      keyboardType: TextInputType.number,
      validator: viewModel.validateYearsOfExperience,
      onChanged: viewModel.updateYearsOfExperience,
    );
  }

  Widget _buildFeesField() {
    return CustomTextField(
      labelText: 'Your Fees (₹)',
      keyboardType: TextInputType.number,
      validator: viewModel.validateFees,
      onChanged: viewModel.updateFees,
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleContinuePressed(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: const Text('Continue'),
    );
  }

  void _handleContinuePressed(BuildContext context) {
    final isValid = formKey.currentState?.validate() ?? false;
    
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    if (state.availability.availableDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }

    viewModel.submitAvailability();
    viewModel.navigateToCertificateScreen(context);
  }
}