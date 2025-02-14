import 'package:flutter/material.dart';

class Distancealert extends StatelessWidget {
  const Distancealert({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
      width: 150,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 1.2),
      ),
      child: Text("Distance Alert",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
    );
  }
}