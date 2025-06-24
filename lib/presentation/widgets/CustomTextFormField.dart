import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Customtextformfield extends StatelessWidget {
  const Customtextformfield({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.onSuffixIconTap,
    required this.prefixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final VoidCallback? onSuffixIconTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr(), // Use .tr() for localization
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Bahnschrift',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text'.tr(); // Localized validation message
                } else
                  return null;
              },
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText.tr(), // Use .tr() for localization
            hintStyle: const TextStyle(fontSize: 14, color: Color(0XFFDCDBDB)),
            prefixIcon: Icon(
              prefixIcon,
              color: const Color(0XFFDCDBDB),
              size: 30,
            ),
            suffixIcon: onSuffixIconTap != null
                ? GestureDetector(
                    onTap: onSuffixIconTap,
                    child: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0XFFDCDBDB),
                      size: 30,
                    ),
                  )
                : null,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xffD5D5D5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
