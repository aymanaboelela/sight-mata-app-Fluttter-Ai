import 'package:flutter/material.dart';

class BlindsettingsContainer extends StatelessWidget {
  const BlindsettingsContainer({super.key, required this.title, required this.icone, this.ontap});
  final String title;
  final IconData icone;
  final VoidCallback? ontap;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ontap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffBFD1DE)
        ),
        child:  Row(
          children: [
            const SizedBox(width: 10,),
          Icon(icone,size: 30,color: Colors.black,),
         const  SizedBox(width: 20,),
          Text(title,style:const  TextStyle(color: Colors.black,fontSize:17,fontWeight: FontWeight.w500)),
      
      
        ],),
      ),
    );
  }
}