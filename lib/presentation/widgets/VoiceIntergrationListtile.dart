import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class VoiceIntergrationListtile extends StatefulWidget {
  const VoiceIntergrationListtile({super.key});

  @override
  State<VoiceIntergrationListtile> createState() =>
      _VoiceIntergrationListtileState();
}

class _VoiceIntergrationListtileState extends State<VoiceIntergrationListtile> {
  bool isSwitched = false;
  String selectedSound = 'mail';

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Color(0xffBFD1DE),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: ListTile(
          leading: const Image(
              image: AssetImage("assets/images/stash_mic-solid.png")),
          title: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Voice Intergration",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: FittedBox(
                  child: Text(
                "",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ))),
          trailing: GestureDetector(
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
      ),
      Container(
        padding: const EdgeInsets.only(left: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: Color(0xffBFD1DE),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Sound",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Radio(
                  value: "Male",
                  groupValue: selectedSound,
                  activeColor: AppColors.primaryBlueColor,
                  onChanged: (value) {
                    setState(() {
                      selectedSound = value.toString();
                    });
                  },
                ),
                const Text("Male"),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: "Female",
                  groupValue: selectedSound,
                  activeColor: AppColors.primaryBlueColor,
                  onChanged: (value) {
                    setState(() {
                      selectedSound = value.toString();
                    });
                  },
                ),
                const Text("Female"),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}
