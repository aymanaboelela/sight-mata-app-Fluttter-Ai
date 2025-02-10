import 'package:flutter/material.dart';

class Settingslisttile extends StatelessWidget {
  const Settingslisttile({super.key, required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:onTap ,
      child: ListTile(
        leading: Icon(icon,size: 40,color: Colors.black),
        title: Text(title,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
      ),
    );
  }
}