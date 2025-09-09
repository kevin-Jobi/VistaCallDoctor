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
    this.controller, 
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
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
        
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
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
