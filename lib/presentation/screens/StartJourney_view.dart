import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class StartJourney extends StatelessWidget {
  final Function() onTap;

  const StartJourney({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 225,
            ),
            GestureDetector(
              onTap: onTap,
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xffADADAD),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 75,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "start_your_journey".tr(), // Translated text
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "start_by_adding_first".tr(), // Translated text
              style: const TextStyle(
                color: Color(0xffADADAD),
              ),
            )
          ],
        ),
      ),
    );
  }
}
