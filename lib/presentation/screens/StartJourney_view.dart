import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/PopMenuListtile.dart';

class StartJourney extends StatelessWidget {
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
            icon: Icon(
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PopupMenuButton<int>(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                  size: 40,
                ),
                onSelected: (value) {
                  if (value == 0) {
                     GoRouter.of(context)
                                  .pushReplacement(AppRouter.KMyProfileView);
                  } else if (value == 1) {
                    GoRouter.of(context)
                                  .pushReplacement(AppRouter.KSettingsView);
                  } else if (value == 2) {
                    print("Logout clicked");
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Popmenulisttile(title: "My Profile", icon: Icons.person,)     // custom ListTile
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child:Popmenulisttile(title: "Settings",icon: Icons.settings,)
                      ),
                     const  PopupMenuItem(
                        value: 2,
                        child:Popmenulisttile(title: "Logout", icon: Icons.logout_outlined)
                      ),
                    ]),
                    const SizedBox(height: 225,)
,            Center(
  child: GestureDetector(
                onTap: () {},
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
),
            const SizedBox(
              height: 15,
            ),
           const  Center(
              child:  Text(
                "Start Your Journey",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          const   Center(
              child:  Text(
                "Start by adding your first to keep you informed\n about the  location and alerts for thier safety.",
                style: TextStyle(
                  color: Color(0xffADADAD),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
