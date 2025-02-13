import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/MyProfileTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';

class MyprofileView extends StatelessWidget {
  const MyprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryBlueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MyPfrofileTextFormField(
              label: "Name",
              hintText: "maryem mahmoud",
            ),
            const MyPfrofileTextFormField(
              label: "Phone Number",
              hintText: "01129416459",
            ),
            const MyPfrofileTextFormField(
              label: "Email",
              hintText: "mamoudmaryem@gmail.com",
            ),
            const MyPfrofileTextFormField(
              label: "Password",
              hintText: "password",
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 250),
              child: Text(
                "Change Password",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Savebutton(onPressed: () {})
          ],
        ),
      ),
    );
  }
}
