import 'package:flutter/material.dart';

class Addanotheruser extends StatelessWidget {
  const Addanotheruser({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_alt_outlined,size: 40,color: Colors.grey,),
          SizedBox(width: 10,),
          Text("Add another One",style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }
}