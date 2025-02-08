import 'package:flutter/material.dart';

class SetDistanceContainer extends StatelessWidget {
  const SetDistanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 265,
      height:25 ,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey,width: 1.2),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const[
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0,3),
            blurRadius: 3
          )
        ]

         
      ),
      child:const  Text("Set the distance from map",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),), 
    );
  }
}