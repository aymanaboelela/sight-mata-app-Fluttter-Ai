import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "notification_page".tr(), // Localized string
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
