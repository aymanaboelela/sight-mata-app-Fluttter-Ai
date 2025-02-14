import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class Savebutton extends StatelessWidget {
  const Savebutton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        alignment: Alignment.center,
        width: 110,
        height: 35,
        decoration: const BoxDecoration(
            color: AppColors.primaryBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(5.0, 5.0), blurRadius: 10)
            ]),
        child: const Text(
          "Save",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SavebuttonOf extends StatelessWidget {
  const SavebuttonOf({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 110,
      height: 35,
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey, offset: Offset(5.0, 5.0), blurRadius: 10)
          ]),
      child: Text(
        "Save",
        style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
