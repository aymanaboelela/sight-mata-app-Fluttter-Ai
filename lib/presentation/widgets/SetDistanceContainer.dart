import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sight_mate_app/presentation/screens/map.dart';

class SetDistanceContainer extends StatelessWidget {
  const SetDistanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapScreen(),
          )),
      child: Container(
        alignment: Alignment.center,
        width: 265,
        height: 25,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1.2),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 3)
            ]),
        child: Text(
          "set_distance".tr(),  // استخدام `tr()` لترجمة النص
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }
}
