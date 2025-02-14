import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/GridView_item.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryBlueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Help",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              const Text(
                "Contact us",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
           const    SizedBox(height: 25,)
,              Expanded(
                child: GridView.count(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children:const  [
                  GridviewItem(
                    image: "assets/images/Vector.png",
                    text1: "WhatsApp Number",
                    text2: "+201096832103",
                  ),
                   GridviewItem(
                    image: "assets/images/Vector (1).png",
                    text1: "Phone Number",
                    text2: "+201090088121",
                  ),
                   GridviewItem(
                    image: "assets/images/Vector (2).png",
                    text1: "Email",
                    text2: "hajarghonim19@gamil.com",
                  ),
                   GridviewItem(
                    image: "assets/images/basil_location-outline.png",
                    text1: "Locatio",
                    text2: "Beni suef / Egypt",
                  )
                    
                    ],
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
