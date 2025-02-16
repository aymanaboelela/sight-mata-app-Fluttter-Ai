import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/presentation/widgets/DIstanceAlert.dart';
import 'package:sight_mate_app/presentation/widgets/Switched_ON.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';

import '../../models/data_mode.dart';

class UserlocationnowView extends StatefulWidget {
  const UserlocationnowView({super.key, required this.data});
  final DataModel data;

  @override
  State<UserlocationnowView> createState() => _UserlocationnowViewState();
}

class _UserlocationnowViewState extends State<UserlocationnowView> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.data.distance == null ? false : true;
  }

  double? newDistance;

  Widget build(BuildContext context) {
    String name = CacheData.getData(key: userNameUser);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryBlueColor,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xff94B2C8),
              child: Icon(Icons.person_2_outlined,
                  size: 30, color: Color(0xff7897AD)),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Hi, $name",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is UpdateDataSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Data Updated")));
          }
          if (state is UpdateDataError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.toString())));
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is UpdateDataLoading,
            progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
            child: Padding(
              padding: EdgeInsets.only(right: 20, left: 20, top: 30),
              child: SingleChildScrollView(
                child: FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff5484A7),
                            ),
                            child: Text(
                              widget.data.username,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 40,
                            color: Colors.black,
                          ),
                          const Text(
                            "Show ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.data.username,
                            style: const TextStyle(
                                color: AppColors.primaryBlueColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            " Location Now",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Row(
                        children: [
                          Distancealert(),
                          SizedBox(
                            width: 30,
                          ),
                          Image(image: AssetImage("assets/images/Edit.png"))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Set Distance Alert",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlueColor),
                          ),
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
                                color: isSwitched
                                    ? AppColors.primaryBlueColor
                                    : Colors.grey[400],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: isSwitched
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Text(
                                        isSwitched ? "on" : "off",
                                        style: TextStyle(
                                          color: isSwitched
                                              ? Colors.white
                                              : Colors.black,
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
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
                          const Spacer(
                            flex: 3,
                          ),
                          const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                            size: 40,
                          ),
                          const SizedBox(
                            height: 90,
                          ),
                        ],
                      ),
                      isSwitched
                          ? FadeInUp(
                              child: SwitchedOn(
                                currentValue: widget.data.distance,
                                onChanged: (p0) {
                                  newDistance = p0;
                                  setState(() {});
                                },
                              ),
                            )
                          : const SizedBox(), // if isSwitched is true, show SwitchedOn (there are inside it a slider and set distance from map) widget

                      const SizedBox(
                        height: 90,
                      ),
                      Center(
                        child: newDistance != null
                            ? Savebutton(
                                onPressed: () {
                                  context.read<DataCubit>().updateData(
                                        email: widget.data.email,
                                        name: widget.data.username,
                                        distance: newDistance,
                                        lat: 30.0,
                                        lon: 40.0,
                                      );
                                },
                              )
                            : SavebuttonOf(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
