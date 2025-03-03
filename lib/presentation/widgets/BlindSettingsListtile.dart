import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class Blindsettingslisttile extends StatefulWidget {
  const Blindsettingslisttile(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle,
      required this.ontap, this.isSwitched});
  final String image;
  final String title;
  final String subtitle;
  final bool? isSwitched;
  final Function(bool)? ontap;

  @override
  State<Blindsettingslisttile> createState() => _BlindsettingslisttileState();
}

class _BlindsettingslisttileState extends State<Blindsettingslisttile> {
  @override
  void initState() {
    isSwitched = widget.isSwitched?? false;
    super.initState();
  }

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 80,
      decoration: BoxDecoration(
          color: const Color(0xffBFD1DE),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image(image: AssetImage(widget.image)),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FittedBox(
                child: Text(
              widget.subtitle,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ))),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              isSwitched = !isSwitched;
              widget.ontap!(isSwitched);
        
              
            });
          },
          child: Container(
            width: 70, // Control width
            height: 25, // Control height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  isSwitched ? AppColors.primaryBlueColor : Colors.grey[400],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: isSwitched
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  alignment: isSwitched
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
