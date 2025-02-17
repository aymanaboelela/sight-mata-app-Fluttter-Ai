import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/editprofile/editprofile_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/presentation/widgets/MyProfileTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/saveButton.dart';

class ChangepasswordView extends StatefulWidget {
  const ChangepasswordView({super.key});

  @override
  State<ChangepasswordView> createState() => _ChangepasswordViewState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController oldPasswordcontroller = TextEditingController();
TextEditingController newPasswordcontroller = TextEditingController();

class _ChangepasswordViewState extends State<ChangepasswordView> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocConsumer<EditprofileCubit, EditprofileState>(
        listener: (context, state) {
          if (state is EditprofileSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Password Updated")));
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
              body: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      MyPfrofileTextFormField(
                        controller: oldPasswordcontroller,
                        label: "Old Password",
                        hintText: "Enter Old Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          return null;
                        },
                      ),
                      MyPfrofileTextFormField(
                        controller: newPasswordcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          return null;
                        },
                        label: "New Password",
                        hintText: 'Enter New Password',
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 250),
                        child: Savebutton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              context.read<EditprofileCubit>().updateProfile(
                                  oldPassword: oldPasswordcontroller.text,
                                  newPassword: newPasswordcontroller.text);
                              Navigator.pop(context);
                            }
                          },
                        ),
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
