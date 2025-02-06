// ignore_for_file: unnecessary_null_comparison

import 'package:vibration/vibration.dart';

Future<void> vibrateDevice() async {
  bool? hasVibrator = await Vibration.hasVibrator();

  if (hasVibrator != null && hasVibrator) {
    Vibration.vibrate();
  } else {
    print('الجهاز لا يدعم الاهتزاز');
  }
}
