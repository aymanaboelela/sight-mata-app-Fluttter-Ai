import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/SetDistanceContainer.dart';
import 'package:easy_localization/easy_localization.dart'; // إضافة الاستيراد لترجمة النصوص

class SwitchedOn extends StatefulWidget {
  const SwitchedOn({super.key, required this.onChanged, this.currentValue});

  @override
  State<SwitchedOn> createState() => _SwitchedOnState();

  final Function(double) onChanged;
  final double? currentValue;
}

class _SwitchedOnState extends State<SwitchedOn> {
  double _currentValue = 0;

  @override
  void initState() {
    _currentValue = widget.currentValue ?? 0;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
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
              widget.onChanged(_currentValue);
            });
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Text(
                "distance".tr(), // استخدام `tr()` لترجمة النص
                style: TextStyle(
                    color: AppColors.primaryBlueColor,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text("$_currentValue ${"km".tr()}", // ترجمة الكلمة "km"
                  style: const TextStyle(
                      color: AppColors.primaryBlueColor,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
         Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "or".tr(), 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 50,
        ),
        const SetDistanceContainer(), // إضافة المسافة من الخريطة
      ],
    );
  }
}
