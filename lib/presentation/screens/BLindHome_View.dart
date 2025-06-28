import 'dart:developer';
import 'dart:ffi';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/service/send_notfication.dart';
import 'package:sight_mate_app/models/data_mode.dart';
import 'package:sight_mate_app/presentation/screens/BLindSettings_View.dart';
import 'package:sight_mate_app/presentation/screens/blind_camera_view.dart';
import 'package:sight_mate_app/presentation/screens/blind_map_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';

class HomeBlindView extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeBlindView> {
  int _page = 0;
  final FlutterTts _tts = FlutterTts();
  final List<Widget> _screens = [
    LiveCameraDetectionScreen(),
    BlindMapView(),
    BlindsettingsView(),
  ];

  int _tapCount = 0;
  DateTime? _firstTapTime;

  @override
  void initState() {
    super.initState();
    getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakWelcomeMessage();
    });
  }

  void getToken() async {
    dataModel = await context.read<DataCubit>().getUserDataByEmail();
  }

  DataModel? dataModel;
  Future<void> _speakWelcomeMessage() async {
    final currentLocale = context.locale.languageCode;

    if (currentLocale == 'ar') {
      await _tts.setLanguage("ar-SA");
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      await _tts.speak(
        "أهلاً بك! نتمنى أن تكون بخير. يمكنك الضغط على الشاشة لمعرفة ما أمامك. ويمكنك الضغط على الشاشة ثلاث مرات متتالية لإرسال إشعار استغاثة إلى المتابع الخاص بك.",
      );
    } else {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      await _tts.speak(
        "Welcome! We hope you are doing well. You can tap the screen to know what's in front of you. You can also tap the screen three times to send a help alert to your follower.",
      );
    }
  }

  void _handleScreenTap() {
    final now = DateTime.now();
    if (_firstTapTime == null ||
        now.difference(_firstTapTime!) > Duration(seconds: 1)) {
      _firstTapTime = now;
      _tapCount = 1;
    } else {
      _tapCount++;
      if (_tapCount == 3) {
        _triggerEmergency();
        _tapCount = 0;
        _firstTapTime = null;
      }
    }
  }

  void ubdateLocation() async {
    final success = await context.read<DataCubit>().updateCurrentLocation(
      isUnTrackingEnabled: false,
    );
    if (success) {
      log("Location updated successfully.");
    } else {
      log("Failed to update location.");
    }
  }

  Future<void> _triggerEmergency() async {
    final currentLocale = context.locale.languageCode;

    if (currentLocale == 'ar') {
      await _tts.setLanguage("ar-SA");
      await _tts.speak("تم إرسال إشعار استغاثة إلى المتابع.");
    } else {
      await _tts.setLanguage("en-US");
      await _tts.speak("Emergency alert sent to your follower.");
    }

    final userToken = dataModel?.followerToken;
    final userName = dataModel?.username ?? "Unknown User";
    log("userToken: $userToken");
    ubdateLocation();
    if (userToken != null) {
      NotificationSender.instance.sendNotification(
        fcmToken: userToken,
        title: currentLocale == 'ar'
            ? "رسالة من $userName"
            : "Message from $userName",
        body: currentLocale == 'ar'
            ? "استغاثة من $userName. يريد متابعه موقعه."
            : "Emergency from $userName. Wants to share location.",
        type: "Blind",
        userId: dataModel?.id ?? "Unknown ID",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleScreenTap,
      child: Scaffold(
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
          index: _page,
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: _screens[_page],
      ),
    );
  }
}
