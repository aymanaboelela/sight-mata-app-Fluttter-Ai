import 'package:flutter/material.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const Text(
              "Start Your Journey",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Start by adding your first to keep you informed\n about the  location and alerts for thier safety.",
              style: TextStyle(
                color: Color(0xffADADAD),
              ),
            )
          ],
        ),
      ),
    );
  }
}
