import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class LocationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "location_page".tr(), // Localized string
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
