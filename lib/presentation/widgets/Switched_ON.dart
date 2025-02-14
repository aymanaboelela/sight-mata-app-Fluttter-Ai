import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/SetDistanceContainer.dart';

class SwitchedOn extends StatefulWidget {
  const SwitchedOn({super.key});

  @override
  State<SwitchedOn> createState() => _SwitchedOnState();
}

class _SwitchedOnState extends State<SwitchedOn> {
    double _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30,),
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
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Text(
                  "0 km",
                  style: TextStyle(
                      color: AppColors.primaryBlueColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text("50 km",
                    style: TextStyle(
                        color: AppColors.primaryBlueColor,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "________________________ OR _________________________",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          const SetDistanceContainer(), // adding the distance form Maps
      ],
    );
  }
}