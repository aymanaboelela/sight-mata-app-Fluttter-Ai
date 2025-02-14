import 'package:flutter/material.dart';

class Popmenulisttile extends StatelessWidget {
  const Popmenulisttile(
      {super.key, required this.title, required this.icon, this.onTap});
  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap,
      leading: Icon(icon),
      title: Text(
        title,
      ),
    );
  }
}
