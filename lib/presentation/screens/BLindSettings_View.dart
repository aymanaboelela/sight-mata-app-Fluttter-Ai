import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';
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
        title: Text(
          "settings".tr(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              BlindsettingsContainer(
                title: "my_profile".tr(),
                image: "assets/images/Group (1).png",
                ontap: () {
                  GoRouter.of(context).push(AppRouter.kMyProfileView);
                },
              ),
              // BlindsettingsContainer(
              //   title: "about".tr(),
              //   image: "assets/images/ix_about.png",
              //   ontap: () {
              //     GoRouter.of(context).push(AppRouter.kAboutView);
              //   },
              // ),
              Blindsettingslisttile(
                isSwitched: isSwitchedactivateTracking,
                image: "assets/images/gis_poi-map.png",
                title: "activate_tracking".tr(),
                subtitle: "tracking_description".tr(),
                ontap: (b3) {
                  if (b3 == false) {
                    context
                        .read<DataCubit>()
                        .updateCurrentLocation(isUnTrackingEnabled: true);
                  } else {
                    context
                        .read<DataCubit>()
                        .updateCurrentLocation(isUnTrackingEnabled: false);
                  }
                  CacheData.setData(
                      key: AppCacheData.activateTracking, value: b3);
                },
              ),
              BlindsettingsContainer(
                title: "about".tr(),
                image: "assets/images/ix_about.png",
                ontap: () {
                  GoRouter.of(context).push(AppRouter.kAboutView);
                },
              ),
              BlindsettingsContainer(
                title: "language".tr(),
                image: "assets/images/language.png",
                ontap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("select_language".tr()),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text("english".tr()),
                            onTap: () {
                              context.setLocale(const Locale('en'));
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text("arabic".tr()),
                            onTap: () {
                              context.setLocale(const Locale('ar'));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              BlindsettingsContainer(
                title: "logout".tr(),
                image: "assets/images/ix_about.png",
                ontap: () {
                  GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                  context.read<AuthCubit>().signOut();
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
