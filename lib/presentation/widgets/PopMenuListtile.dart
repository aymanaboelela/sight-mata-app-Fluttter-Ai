import 'package:flutter/material.dart';

class Popmenulisttile extends StatelessWidget {
  const Popmenulisttile({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
      ),
    );
  }
}
