import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/screens/BLindSettings_View.dart';
import 'package:sight_mate_app/presentation/screens/BlindCamera_view.dart';
import 'package:sight_mate_app/presentation/screens/blind_map_view.dart';
class HomeBlindView extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeBlindView> {
  int _page = 0;

  // List of screens to switch between
  final List<Widget> _screens = [
    VoiceAICommunicationPage(),
  BlindMapView(),
    BlindsettingsView(),

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
          Icon(Icons.camera_alt_outlined, size: 35, color: Colors.white),
          Icon(Icons.location_on, size: 35, color: Colors.white),
          Icon(Icons.settings, size: 35, color: Colors.white),
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
//
