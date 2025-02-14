import 'package:flutter/material.dart';
import 'package:sight_mate_app/presentation/widgets/MyProfileTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';

class ChangepasswordView extends StatelessWidget {
  const ChangepasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Change Password",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            const MyPfrofileTextFormField(
              label: "Old Password",
              hintText: "Enter Old Password",
            ),
            const MyPfrofileTextFormField(
              label: "New Password",
              hintText: 'Enter New Password',
            ),
            const MyPfrofileTextFormField(
              label: "Confirm New Password",
              hintText: "Confirm New Password",
            ),
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 250),
              child: Savebutton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
