import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class AboutView extends StatelessWidget {
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
          "About",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "sight",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 5,),
                Icon(FontAwesomeIcons.eye, size: 30),
                SizedBox(width: 10,),
                Text(
                  "mate",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'inter',
                  ),
                ),
              ],
            ),

            SizedBox(height: 100), // Spacing

            // App Title
            Text(
              "Sight Mate",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),

            // Subtitle
            Text(
              "your assistant in app",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 25),

            // Description Text
            Text(
              "Sight Mate is an app designed\n to support visually impaired\n individuals\n "
              "by enhancing their independence\n and safety. With features like object\n recognition\n, "
              "text reading, danger alerts, and\n real-time location tracking, we aim\n to connect users "
              "with their loved\n ones and make life simpler and\n more inclusive.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}