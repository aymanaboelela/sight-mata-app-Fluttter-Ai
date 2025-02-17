import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/editprofile/editprofile_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/presentation/screens/changePassword_view.dart';
import 'package:sight_mate_app/presentation/widgets/MyProfileTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';

class MyprofileView extends StatefulWidget {
  const MyprofileView({super.key});

  @override
  State<MyprofileView> createState() => _MyprofileViewState();
}

class _MyprofileViewState extends State<MyprofileView> {
  TextEditingController? nameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditprofileCubit, EditprofileState>(
      listener: (context, state) {
        if (state is EditprofileSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Profile Updated")));
        } else if (state is EditprofileError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is EditprofileLoading,
          progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
          child: Scaffold(
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
                "My Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  MyPfrofileTextFormField(
                    onChanged: (p0) {
                      setState(() {});
                    },
                    controller: nameController,
                    label: "Name",
                    hintText: CacheData.getData(key: userNameUser),
                  ),
                  MyPfrofileTextFormField(
                    onChanged: (p0) {
                      setState(() {});
                    },
                    controller: phoneController,
                    label: "Phone Number",
                    hintText: CacheData.getData(key: phoneCahnged),
                  ),
                  MyPfrofileTextFormField(
                    onChanged: (p0) {
                      setState(() {});
                    },
                    controller: emailController,
                    label: "Email",
                    hintText: CacheData.getData(key: emailChanged),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 250),
                    child: GestureDetector(
                      onTap: () {
                        // تم تمرير BlocProvider للقيم بشكل صحيح
                        showModalBottomSheet(
                          context: context,
                          // isScrollControlled:
                          //     true, // Makes it possible to control height
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Align(
                              alignment:
                                  Alignment.center, // Moves it to the center
                              child: Container(
                                width: double.infinity,
                                // height: 475,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ChangepasswordView(),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Change Password",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  nameController!.text.isEmpty &&
                          phoneController!.text.isEmpty &&
                          emailController!.text.isEmpty
                      ? const SavebuttonOf()
                      : Savebutton(onPressed: () {
                          context.read<EditprofileCubit>().updateProfile(
                              newName: nameController?.text,
                              newPhone: phoneController?.text,
                              newEmail: emailController?.text);
                        }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
