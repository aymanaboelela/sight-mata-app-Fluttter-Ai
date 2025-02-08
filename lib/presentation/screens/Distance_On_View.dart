import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/CustomTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/SetDistanceContainer.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';

class DistanceONView extends StatefulWidget {
  const DistanceONView({super.key});

  @override
  State<DistanceONView> createState() => _DistanceONViewState();
}

class _DistanceONViewState extends State<DistanceONView> {
  bool isSwitched = false; // Initial state
    double _currentValue = 0;


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.primaryBlueColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
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
      body:  Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            const Customtextformfield(
              label: "User's Name",
              hintText: 'Enter name',
              prefixIcon: Icons.person_3_outlined,
            ),
          const SizedBox(height: 20,),
            const Customtextformfield(
              label: "Email",
              hintText:"Enter User's Email",
              prefixIcon: Icons.email_outlined,
            ),
           const SizedBox(height: 30,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const   Text("Set Distance Alert",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlueColor
              ),),
              Spacer(),


              
                GestureDetector(
          onTap: () {
            setState(() {
              isSwitched = !isSwitched;
            });
          },
          child: Container(
            width: 70, // Control width
            height: 25, // Control height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSwitched ? AppColors.primaryBlueColor : Colors.grey[400],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: isSwitched ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      isSwitched ? "on" : "off",
                      style: TextStyle(
                        color: isSwitched ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  alignment: isSwitched ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration:const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
                const Spacer(flex: 3,),
                const Icon(Icons.info_outline,color: Colors.grey,size: 40,)
              ],
            ),
            const SizedBox(height: 50,),
             Slider(
              value: _currentValue,
              min: 0,
              max: 50,
              divisions: 50,
              activeColor: AppColors.primaryBlueColor,
              inactiveColor: Colors.grey,
              thumbColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
              },
            ),
           const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 25),
              child:  Row(
                children: [
                  Text("0 km",style: TextStyle(color: AppColors.primaryBlueColor,fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text("50 km",style: TextStyle(color: AppColors.primaryBlueColor,fontWeight: FontWeight.bold))
                ],
              ),
              
            ),
           const  SizedBox(height: 20,),
           const  Text("________________________ OR _________________________",
            style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 50,),
            const SetDistanceContainer(),    // adding the distance form Maps
            const SizedBox(height: 80,),
            Savebutton(onPressed: (){})
            
          ]
        ),
      ),
    );
  }
}
