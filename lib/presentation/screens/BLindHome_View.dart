import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/screens/BLindSettings_View.dart';
import 'package:sight_mate_app/presentation/screens/blind_camera_view.dart';
import 'package:sight_mate_app/presentation/screens/blind_map_view.dart';
import 'package:easy_localization/easy_localization.dart'; // مهم

class HomeBlindView extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeBlindView> {
  int _page = 0;
  final FlutterTts _tts = FlutterTts();

  final List<Widget> _screens = [
    VoiceAICommunicationPage(),
    BlindMapView(),
    BlindsettingsView(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakWelcomeMessage();
    });
  }

  Future<void> _speakWelcomeMessage() async {
    final currentLocale = context.locale.languageCode; // 'ar' أو 'en'

    if (currentLocale == 'ar') {
      await _tts.setLanguage("ar-SA");
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      await _tts.speak(
        "أهلاً بك! نتمنى أن تكون بخير. يمكنك الضغط على الشاشة لمعرفة ما أمامك. ويمكنك الضغط على زر الباور مرتين لإرسال إشعار استغاثة إلى المتابع الخاص بك.",
      );
    } else {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      await _tts.speak(
        "Welcome! We hope you are doing well. You can tap the screen to know what's in front of you. You can also double press the power button to send a help alert to your follower.",
      );
    }
  }

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
        index: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _screens[_page],
    );
  }
}
