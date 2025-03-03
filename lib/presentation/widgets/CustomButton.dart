import 'package:flutter/material.dart';

class Custombottom extends StatelessWidget {
  const Custombottom({super.key, required this.text, this.onpressed});
  final String text;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        color:const Color(0xff46325D),
        minWidth: 380,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: onpressed,
         child: Text(text,
        style:const  TextStyle(
          color: Colors.white,
          fontFamily: 'Bahnschrift',
          fontWeight: FontWeight.w600,
          fontSize: 16
        ),),
        ),
        
    );
  }
}
