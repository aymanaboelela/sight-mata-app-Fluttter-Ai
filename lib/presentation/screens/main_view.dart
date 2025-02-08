import 'package:flutter/material.dart';
import 'package:sight_mate_app/presentation/screens/Distance_Off_view.dart';
import 'package:sight_mate_app/presentation/screens/Distance_On_View.dart';
import 'package:sight_mate_app/presentation/screens/StartJourney_view.dart';
import 'package:sight_mate_app/presentation/screens/Users_views.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        StartJourney(),
        DistanceOffView(),
        DistanceONView(),
        UsersViews()
      ],
    );
  }
}