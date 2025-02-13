import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/PopMenuListtile.dart';

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
            Padding(
              padding: const EdgeInsets.only(left: 300),
              child: PopupMenuButton<int>(
                  icon: const Icon(Icons.more_horiz,
                      size: 30), // Three-dot menu icon
                  onSelected: (value) {
                    if (value == 0) {
                      GoRouter.of(context).pushReplacement(AppRouter.KMyProfileView);
                    } else if (value == 1) {
                      GoRouter.of(context).pushReplacement(AppRouter.KSettingsView);
                    } else if (value == 2) {
                      print("Logout clicked");
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 0,
                            child: Popmenulisttile(
                              title: "My Profile",
                              icon: Icons.person,
                            )),
                        const PopupMenuItem(
                            value: 1,
                            child: Popmenulisttile(
                              title: "Settings",
                              icon: Icons.settings,
                            )),
                        const PopupMenuItem(
                            value: 2,
                            child: Popmenulisttile(
                              title: "Logout",
                              icon: Icons.logout,
                            ))
                      ]),
            ),
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
