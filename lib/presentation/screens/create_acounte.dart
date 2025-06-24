import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';

import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/CustomButton.dart';
import 'package:sight_mate_app/presentation/widgets/CustomTextFormField.dart';
import 'package:sight_mate_app/presentation/widgets/UserType.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false; // variable for password visibility
  TextEditingController? nameController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? verifyPasswordController = TextEditingController();
  bool isadmin = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is CreateSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("email_verification".tr()), // Translated title
                content: Text("verification_email_sent".tr()), // Translated content
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      GoRouter.of(context).pushReplacement(
                          AppRouter.kLoginView); // Navigate to the login page
                    },
                    child: Text("ok".tr()), // Translated button text
                  ),
                ],
              );
            },
          );
        } else if (state is CreateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: state is CreateLoading,
              progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("sign_up".tr(), // Translated text
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'Bahnschrift',
                              color: Color(0xff46325D),
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      Customtextformfield(
                        controller: nameController,
                        label: "name".tr(), // Translated label
                        hintText: "enter_your_name".tr(), // Translated hint text
                        prefixIcon: Icons.person_2_outlined,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Customtextformfield(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        label: "phone_number".tr(), // Translated label
                        hintText: "enter_your_phone".tr(), // Translated hint text
                        prefixIcon: Icons.lock_outlined,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Customtextformfield(
                        controller: emailController,
                        label: "email".tr(), // Translated label
                        hintText: "enter_your_email".tr(), // Translated hint text
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Customtextformfield(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return "enter_password".tr(); // Translated error message
                          } else if (p0.length < 8) {
                            return "password_min_length".tr(); // Translated error message
                          }
                          return null;
                        },
                        controller: passwordController,
                        label: "password".tr(), // Translated label
                        hintText: "enter_your_password".tr(), // Translated hint text
                        prefixIcon: Icons.lock_outlined,
                        obscureText: !isPasswordVisible,
                        onSuffixIconTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Customtextformfield(
                        validator: (p0) {
                          if (p0 != passwordController?.text) {
                            return "password_mismatch".tr(); // Translated error message
                          } else if (verifyPasswordController!.text.isEmpty) {
                            return "enter_verify_password".tr(); // Translated error message
                          }
                          return null;
                        },
                        controller: verifyPasswordController,
                        label: "verify_password".tr(), // Translated label
                        hintText: "enter_your_password".tr(), // Translated hint text
                        prefixIcon: Icons.lock_outlined,
                        obscureText: !isPasswordVisible,
                        onSuffixIconTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Usertype(
                        isAdmin: (p0) {
                          isadmin = p0;
                        },
                      ), //toggle button to determine user Type
                      const SizedBox(
                        height: 20,
                      ),
                      Custombottom(
                          text: "create_account".tr(), // Translated text
                          onpressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().createAccount(
                                  isAdmin: isadmin,
                                  email: emailController!.text,
                                  password: passwordController!.text,
                                  userName: nameController!.text,
                                  phone: phoneController!.text);
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "already_have_account".tr(), // Translated text
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Bahnschrift'),
                          ),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context)
                                  .pushReplacement(AppRouter.kLoginView);
                            },
                            child: Text(
                              "login".tr(), // Translated text
                              style: const TextStyle(
                                  color: Color(0xff46325D),
                                  fontSize: 14,
                                  fontFamily: 'Bahnschrift'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
