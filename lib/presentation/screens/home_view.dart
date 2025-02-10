
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/screens/Location_view.dart';
import 'package:sight_mate_app/presentation/screens/Notification_view.dart';
import 'package:sight_mate_app/presentation/screens/main_View.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeView> {
  int _page = 0;

  // List of screens to switch between
  final List<Widget> _screens = [
    MainView(),
    LocationView(),
    NotificationView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: AppColors.primaryBlueColor,
        height: 60,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.location_on, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
        ],
        index: _page, // Set the initial selected index
        onTap: (index) {
          setState(() {
            _page = index; // Change the screen index
          });
        },
      ),
      body: _screens[_page], // Display the selected screen
    );
  }
}

