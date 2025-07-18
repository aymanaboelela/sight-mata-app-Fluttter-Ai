import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/cach_data_const.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/core/service/send_notfication.dart';
import 'package:sight_mate_app/presentation/screens/map.dart';
import 'package:sight_mate_app/presentation/widgets/CustomTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/Switched_ON.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';
import 'package:easy_localization/easy_localization.dart';

class DistanceOffView extends StatefulWidget {
  const DistanceOffView({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<DistanceOffView> createState() => _DistanceOffViewState();
}

class _DistanceOffViewState extends State<DistanceOffView> {
  bool isSwitched = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  double? distance;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is AddDataSuccess) {
            widget.onTap();
            context.read<DataCubit>().getData();
          } else if (state is AddDataError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Blind User Not Found".tr())));
          } else if (state is UserTokenFound) {
            final userName = CacheData.getData(key: userNameUser);
            NotificationSender.instance.sendNotification(
              fcmToken: state.userToken.fcmToken,
              title: "رساله من $userName",
              body: "$userName يريد متابعتك لمعرفه موقعك",
              type: "follow_request",
              userId: state.userToken.id,
            );
            context.read<DataCubit>().addData(
                  followerToken:
                      CacheData.getData(key: AppCacheData.deviceToken),
                  blindToken: state.userToken.fcmToken,
                  name: nameController.text,
                  email: emailController.text,
                  distance: distance,
                  lat: selectedLocation?.latitude,
                  lon: selectedLocation?.longitude,
                );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is AddDataLoading ||
                state is GetDataLoading ||
                state is DeleteDataLoading,
            progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Customtextformfield(
                        controller: nameController,
                        label: "User's Name".tr(),
                        hintText: 'Enter name'.tr(),
                        prefixIcon: Icons.person_3_outlined,
                      ),
                      const SizedBox(height: 20),
                      Customtextformfield(
                        controller: emailController,
                        label: "Email".tr(),
                        hintText: "Enter User's Email".tr(),
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Set Distance Alert".tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlueColor,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSwitched = !isSwitched;
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isSwitched
                                    ? AppColors.primaryBlueColor
                                    : Colors.grey[400],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 200),
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
                                  Align(
                                    alignment: isSwitched
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Text(
                                        isSwitched ? "on".tr() : "off".tr(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(flex: 3),
                          const Icon(Icons.info_outline,
                              color: Colors.grey, size: 40),
                        ],
                      ),
                      if (isSwitched)
                        SwitchedOn(
                          onChanged: (p0) {
                            distance = p0;
                          },
                        ),
                      const SizedBox(height: 90),
                      Savebutton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<DataCubit>().checkEmailAndFetchToken(
                                  email: emailController.text,
                                );
                          }
                        },
                      ),
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
