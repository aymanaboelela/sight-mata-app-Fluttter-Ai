import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/AddAnotherUser.dart';
import 'package:sight_mate_app/presentation/widgets/UserListtile.dart';

class UsersViews extends StatelessWidget {
  const UsersViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.primaryBlueColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xff94B2C8),
              child: Icon(
                Icons.person_outlined,
                color: Color(0xff7897AD),
                size: 25,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Hi, Basmala.",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Bahnschrift',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body:const  Padding(
        padding:  EdgeInsets.only(top: 50),
        child: Column(
          children: [
            UserListtile(),
            SizedBox(height: 75,),
            Addanotheruser()
          ],
        ),
      ),
    );
  }
}