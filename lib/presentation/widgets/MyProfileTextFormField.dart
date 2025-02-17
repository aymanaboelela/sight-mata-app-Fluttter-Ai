import 'package:flutter/material.dart';

class MyPfrofileTextFormField extends StatelessWidget {
  const MyPfrofileTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
  });

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            validator: validator,
            obscureText: label.toLowerCase().contains('password'), // Hide password text
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xffD5D5D5)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
