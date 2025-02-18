import 'package:flutter/material.dart';

class BlindsettingsContainer extends StatelessWidget {
  const BlindsettingsContainer({super.key, required this.title, required this.image, this.ontap});
  final String title;
  final String image;
  final VoidCallback? ontap;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ontap,
      child: Container(
        margin:const  EdgeInsets.only(bottom: 15),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffBFD1DE)
        ),
        child:  Row(
          children: [
            const SizedBox(width: 10,),
            Image(image: AssetImage(image)),
         const  SizedBox(width: 20,),
          Text(title,style:const  TextStyle(color: Colors.black,fontSize:17,fontWeight: FontWeight.bold)),
      
      
        ],),
      ),
    );
  }
}