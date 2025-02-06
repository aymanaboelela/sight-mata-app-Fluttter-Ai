import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.primaryBlueColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
         icon:Icon(Icons.arrow_back_ios,color: Colors.white,) ),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xff94B2C8),
              child: Icon(
                Icons.person_outlined,
                color: Color(0xff7897AD),
                size: 25,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Hi, Basmala.",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Bahnschrift',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xffADADAD),
              child: Icon(Icons.add,color: Colors.white,size: 75,),
            ),
            SizedBox(height: 15,),
            Text("Start Your Journey",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black),),
            SizedBox(height: 5,)
            ,Text("Start by adding your first to keep you informed\n about the  location and alerts for thier safety.",
            style:TextStyle(color: Color(0xffADADAD),) ,)
            ],
        ),
      ),
    );
  }
}
