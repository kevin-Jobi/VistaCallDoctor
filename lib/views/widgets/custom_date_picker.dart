import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerField extends StatelessWidget {
  final String labelText;
  final String value;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  // final TextEditingController controller;

  const CustomDatePickerField({
    Key? key,
    required this.labelText,
    required this.value,
    this.validator,
    this.onChanged,
    // required this.controller,
  }) : super(key: key);

  Future<void> _selectDate(
    BuildContext context,
    // TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      cancelText: 'Cancel',
      confirmText: 'Select',
      fieldLabelText: 'Date of Birth',
      fieldHintText: 'Month/Day/Year',
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      // widget.controller.text = formattedDate;
      // if (onChanged != null) {
      onChanged!(formattedDate);
      // }
      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_today),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 229, 229, 229),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
