import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class Generalsettings extends StatefulWidget {
  const Generalsettings({super.key});

  @override
  State<Generalsettings> createState() => _GeneralsettingsState();
}

class _GeneralsettingsState extends State<Generalsettings> {
  double _currentValue = 20.0; // initial slider value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlueColor,
        centerTitle: true,
        title: const Text(
          "General",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 5, left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffBFD1DE)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Volume Level",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Image(
                          image: AssetImage("assets/images/Vector (3).png")),
                      Slider(
                          value: _currentValue,
                          min: 0,
                          max: 200,
                          divisions:
                              20,
                          label: _currentValue.round().toString(),
                          activeColor:
                              AppColors.primaryBlueColor, 
                          inactiveColor:
                              Colors.grey,
                          onChanged: (double newValue) {
                            setState(() {
                              _currentValue = newValue;
                            });
                          }),
                      const Image(image: AssetImage("assets/images/Vector (4).png"))
                    ],
                  ),
                ],
              ),
              
            ),
            SizedBox(height: 30,),
            Container(
              height: 130,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 10,right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffBFD1DE)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Image(image: AssetImage("assets/images/Vector (5).png")),
                      SizedBox(width: 10,),
                      Text("Select Language",style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 20),
        child: Container(
          color: Colors.white,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Language',
              hintText: 'Enter your language',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Handle the input value
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your language';
              }
              return null;
            },
          ),
        ),
      ),
                ],
              ),
        )],
        ),
      ),
    );
  }
}
