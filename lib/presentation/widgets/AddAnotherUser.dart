import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class Addanotheruser extends StatelessWidget {
  const Addanotheruser({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_add_alt_outlined, size: 40, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            "add_another_user".tr(),  // Localized text
            style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
