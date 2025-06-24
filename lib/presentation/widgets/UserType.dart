import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // إضافة الاستيراد لترجمة النصوص

class Usertype extends StatefulWidget {
  const Usertype({super.key, required this.isAdmin});
  final Function(bool) isAdmin;

  @override
  State<Usertype> createState() => _UsertypeState();
}

class _UsertypeState extends State<Usertype> {
  List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'visually_impaired'.tr(), // استخدام `tr()` لترجمة النص
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            'fellow'.tr(), // استخدام `tr()` لترجمة النص
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      isSelected: _isSelected,
      onPressed: (index) {
        setState(() {
          for (int i = 0; i < _isSelected.length; i++) {
            _isSelected[i] = (i == index);
            widget.isAdmin(_isSelected[i]);
          }
        });
      },
      // Optional styling
      borderRadius: BorderRadius.circular(30),
      selectedColor: Colors.white, // selected Text color
      fillColor: const Color.fromARGB(255, 120, 98, 146),
      color: Colors.black, // unselected Text color
    );
  }
}
