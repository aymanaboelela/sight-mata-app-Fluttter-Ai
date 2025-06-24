import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Distancealert extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;

  const Distancealert({
    super.key,
    this.label = "Distance Alert",
    this.borderColor = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 150,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(10), // Optional rounded corners
      ),
      child: Text(
        label.tr(), // Make label translatable
        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
