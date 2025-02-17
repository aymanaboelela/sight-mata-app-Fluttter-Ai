import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/presentation/widgets/CustomTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/Switched_ON.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';

class DistanceOffView extends StatefulWidget {
  const DistanceOffView({super.key, required this.onTap});
  final Function() onTap;
  @override
  State<DistanceOffView> createState() => _DistanceOffViewState();
}

class _DistanceOffViewState extends State<DistanceOffView> {
  bool isSwitched = false;
  TextEditingController? nameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  double ?distance ;

  @override
  // ignore: override_on_non_overriding_member
  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is AddDataSuccess) {
            widget.onTap();
            context.read<DataCubit>().getData();
          } else if (state is AddDataError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is AddDataLoading,
            progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Customtextformfield(
                        controller: nameController,
                        label: "User's Name",
                        hintText: 'Enter name',
                        prefixIcon: Icons.person_3_outlined,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Customtextformfield(
                        controller: emailController,
                        label: "Email",
                        hintText: "Enter User's Email",
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 30,
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
                          )
                        ],
                      ),

                      isSwitched
                          ? SwitchedOn(
                              onChanged: (p0) {
                                distance = p0;
                              },
                            )
                          : const SizedBox(), // if isSwitched is true, show SwitchedOn (there are inside it a slider and set distance from map) widget

                      const SizedBox(
                        height: 90,
                      ),
                      Savebutton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<DataCubit>().addData(
                                name: nameController!.text,
                                email: emailController!.text,
                                distance: distance,
                                lat: 10,
                                lon: 10);
                          }
                        },
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
