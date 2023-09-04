import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String value) onChanged;
  final TextInputType textInputType;
  final String? Function(String? value) validator;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassowrdField;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final String? initialValue;

  const CustomTextField({
    Key? key,
    required this.onChanged,
    required this.textInputType,
    required this.validator,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassowrdField = false,
    this.contentPadding = const EdgeInsets.fromLTRB(12, 8, 12, 8),
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: onChanged,
        keyboardType: textInputType,
        validator: validator,
        obscureText: isPassowrdField,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          fillColor: const Color(0xff262626),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon:
              prefixIcon != null ? Icon(prefixIcon, color: Colors.white) : null,
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontSize: 14.0,
            letterSpacing: 1.0,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
