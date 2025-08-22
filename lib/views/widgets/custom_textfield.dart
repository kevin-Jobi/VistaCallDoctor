// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Add this import

// class CustomTextField extends StatelessWidget {
//   final TextEditingController? controller;
//   final String? labelText;
//   final String? hintText;
//   final IconData? prefixIcon;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final EdgeInsetsGeometry padding;
//   final bool showVisibilityToggle;
//   final VoidCallback? onVisibilityToggle;
//   final bool isPasswordVisible;
//   final String? Function(String?)? validator;
//   final ValueChanged<String>? onChanged;
//   final VoidCallback? onToggleVisibility;
//   final bool isPasswordField;
//   final IconButton? suffixIcon;
//   final bool isDateField;
//   final DateTime? initialDate; // New property for initial date
//   final DateTime? firstDate; // New property for earliest selectable date
//   final DateTime? lastDate; // New property for latest selectable date

//   const CustomTextField({
//     super.key,
//     this.controller,
//     this.labelText,
//     this.hintText,
//     this.prefixIcon,
//     this.obscureText = false,
//     this.keyboardType,
//     this.padding = const EdgeInsets.symmetric(vertical: 8.0),
//     this.showVisibilityToggle = false,
//     this.onVisibilityToggle,
//     this.isPasswordVisible = false,
//     this.onToggleVisibility,
//     this.validator,
//     this.onChanged,
//     this.isPasswordField = false,
//     this.suffixIcon,
//     this.isDateField = false,
//     this.initialDate,
//     this.firstDate,
//     this.lastDate,
//   });

//   Future<void> _selectDate(
//     BuildContext context,
//     // TextEditingController controller,
//   ) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate:
          
//           DateTime.now().subtract(const Duration(days: 365 * 18)),
//       firstDate:  DateTime(1900),
//       lastDate:  DateTime.now(),
//     );

//     if (picked != null ) {
//       // final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
//       controller!.text = DateFormat('yyyy-MM-dd').format(picked);
//       if (onChanged != null) {
//         onChanged!(controller!.text);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _controller =
//         controller ?? TextEditingController();
//     return Padding(
//       padding: padding,
//       child: TextFormField(
//         controller: _controller,
//         obscureText: isPasswordField ? !isPasswordVisible : obscureText,
//         // obscureText: obscureText,
//         keyboardType: isDateField? TextInputType.none: keyboardType,
//         readOnly: isDateField,
//         decoration: InputDecoration(
//           labelText: labelText,
//           hintText: hintText,
//           prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//           // prefixIcon: Icon(prefixIcon),
//           // suffixIcon: isPasswordField
//           //     ? IconButton(
//           //         icon: Icon(
//           //           isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//           //           color: Colors.grey,
//           //         ),
//           //         onPressed: onToggleVisibility,
//           //       )
//           //     : null,
//           // suffixIcon: suffixIcon,
//           suffixIcon: _buidSuffixIcon(context, _controller),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: const Color.fromARGB(255, 229, 229, 229),
//           // errorText: validator?.call(controller?.text), // Display error if validator fails
//         ),
//         validator: validator,
//         onChanged: isDateField ? null : onChanged,
//         onTap: isDateField ? () => _selectDate(context, ) : null,
//       ),
//     );
//   }

//   Widget? _buidSuffixIcon(
//     BuildContext context,
//     TextEditingController controller,
//   ) {
//     if (suffixIcon != null) return suffixIcon;

//     if (isPasswordField && onToggleVisibility != null) {
//       return IconButton(
//         onPressed: onToggleVisibility,
//         icon: Icon(
//           isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//           color: Colors.grey,
//         ),
//       );
//     } else if (isDateField) {
//       return IconButton(
//         onPressed: () => _selectDate(context, ),
//         icon: const Icon(Icons.calendar_today),
//       );
//     }
//     return null;
//   }
// }

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry padding;
  final bool showVisibilityToggle;
  final VoidCallback? onVisibilityToggle;
  final bool isPasswordVisible;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onToggleVisibility;
  final bool isPasswordField;
  final IconButton? suffixIcon;

  const CustomTextField({
    super.key,
    this.controller, // should be mandatory
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.showVisibilityToggle = false,
    this.onVisibilityToggle,
    this.isPasswordVisible = false,
    this.onToggleVisibility,
    this.validator,
    this.onChanged,
    this.isPasswordField = false, 
    this. suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        // obscureText: isPasswordField ? !isPasswordVisible : obscureText,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          // prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          prefixIcon: Icon(prefixIcon),
          // suffixIcon: isPasswordField
          //     ? IconButton(
          //         icon: Icon(
          //           isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          //           color: Colors.grey,
          //         ),
          //         onPressed: onToggleVisibility,
          //       )
          //     : null,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 229, 229, 229),
          // errorText: validator?.call(controller?.text), // Display error if validator fails
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

