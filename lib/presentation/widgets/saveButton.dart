import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class Savebutton extends StatelessWidget {
  const Savebutton({super.key, required this.onPressed});
 final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
      alignment: Alignment.center,
         width: 110,
         height: 35,
         decoration: const BoxDecoration(
          color: AppColors.primaryBlueColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(5.0, 5.0), 
              blurRadius: 10
            )
            
          ]
          
         ),
         child: const Text("Save",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
      ),
    );
  }
}