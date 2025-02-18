import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/BlindSettingsListtile.dart';
import 'package:sight_mate_app/presentation/widgets/BlindSettings_container.dart';
import 'package:sight_mate_app/presentation/widgets/VoiceIntergrationListtile.dart';

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
      body:  SingleChildScrollView(
        child: Padding(
          padding:const  EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
            BlindsettingsContainer(title: "My Profile", image: "assets/images/Group (1).png",ontap: () {
              
            },),
            BlindsettingsContainer(title: "General", image: "assets/images/iconoir_ios-settings.png",ontap: () {
              GoRouter.of(context).pushReplacement(AppRouter.KGeneralSettings);
            },),
            BlindsettingsContainer(title: "About", image: "assets/images/ix_about.png",ontap: () {
              
            },),
            Blindsettingslisttile(image:"assets/images/game-icons_3d-stairs.png" ,title: "Object Recognition",subtitle: 'The app will analyze the object around you',ontap: () {
              
            },),
           Blindsettingslisttile(image:"assets/images/Group (2).png" ,title: "Text Reading",subtitle: 'The app will read the text on signs or papers',ontap: () {
             
           },),
           Blindsettingslisttile(image: "assets/images/gis_poi-map.png", title: "Activate Tracking", subtitle: "when you activate this feature, the follower can know your location",ontap: () {
             
           },),
           const VoiceIntergrationListtile()

            
            

            ],
          ),
        ),
      ),
    );
  }
}
