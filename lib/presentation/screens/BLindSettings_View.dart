import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/BlindSettings_container.dart';

class BlindsettingsView extends StatelessWidget {
  const BlindsettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlueColor,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              BlindsettingsContainer(
                title: "My Profile",
                icone: Icons.person,
              ),
              BlindsettingsContainer(
                title: "General",
                icone: Icons.generating_tokens,

              ),
               BlindsettingsContainer(
                title: "About",
                icone: Icons.ice_skating,
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
