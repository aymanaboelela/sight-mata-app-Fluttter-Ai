import 'package:flutter/material.dart';

class GridviewItem extends StatelessWidget {
  const GridviewItem({super.key, required this.image, required this.text1, required this.text2});
  final String image;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return   Container(
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Image.asset(image),
                       const  SizedBox(height: 10,),
                         Text(text1,style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                        const  SizedBox(height: 10,),
                         FittedBox(child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 10),
                           child: Text(text2,style:const  TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                         )),
                      ],
                    ),
                   );
  }
}