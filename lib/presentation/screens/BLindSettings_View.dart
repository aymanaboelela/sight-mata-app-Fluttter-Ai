import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart';
import 'package:sight_mate_app/core/constants/cach_data_const.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/BlindSettingsListtile.dart';
import 'package:sight_mate_app/presentation/widgets/BlindSettings_container.dart';
import 'package:sight_mate_app/presentation/widgets/VoiceIntergrationListtile.dart';

class BlindsettingsView extends StatefulWidget {
  const BlindsettingsView({super.key});

  @override
  State<BlindsettingsView> createState() => _BlindsettingsViewState();
}

class _BlindsettingsViewState extends State<BlindsettingsView> {
  @override
  void initState() {
    isSwitchedObjectRecognition =
        CacheData.getData(key: AppCacheData.objectRecognition) ?? false;
    isSwitchedtextReading =
        CacheData.getData(key: AppCacheData.textReading) ?? false;
    isSwitchedactivateTracking =
        CacheData.getData(key: AppCacheData.activateTracking) ?? false;
    super.initState();
  }

  bool isSwitchedObjectRecognition = false;
  bool isSwitchedtextReading = false;
  bool isSwitchedactivateTracking = false;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              BlindsettingsContainer(
                title: "My Profile",
                image: "assets/images/Group (1).png",
                ontap: () {
                  GoRouter.of(context).push(AppRouter.kMyProfileView);
                },
              ),
              BlindsettingsContainer(
                title: "General",
                image: "assets/images/iconoir_ios-settings.png",
                ontap: () {
                  GoRouter.of(context).push(AppRouter.KGeneralSettings);
                },
              ),
              BlindsettingsContainer(
                title: "About",
                image: "assets/images/ix_about.png",
                ontap: () {
                  GoRouter.of(context).push(AppRouter.kAboutView);
                },
              ),
              Blindsettingslisttile(
                isSwitched: isSwitchedObjectRecognition,
                image: "assets/images/game-icons_3d-stairs.png",
                title: "Object Recognition",
                subtitle: 'The app will analyze the object around you',
                ontap: (b1) {
                  CacheData.setData(
                      key: AppCacheData.objectRecognition, value: b1);
                },
              ),
              Blindsettingslisttile(
                isSwitched: isSwitchedtextReading,
                image: "assets/images/Group (2).png",
                title: "Text Reading",
                subtitle: 'The app will read the text on signs or papers',
                ontap: (b2) {
                  CacheData.setData(key: AppCacheData.textReading, value: b2);
                },
              ),
              Blindsettingslisttile(
                isSwitched: isSwitchedactivateTracking,
                image: "assets/images/gis_poi-map.png",
                title: "Activate Tracking",
                subtitle: "the follower can know your location",
                ontap: (b3) {
                  CacheData.setData(
                      key: AppCacheData.activateTracking, value: b3);
                },
              ),
              const VoiceIntergrationListtile(),
              SizedBox(height: 20),
              BlindsettingsContainer(
                title: "Logout",
                image: "assets/images/ix_about.png",
                ontap: () {
                  GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                  context.read<AuthCubit>().signOut();
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
