import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/cach_data_const.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/CustomButton.dart';
import 'package:sight_mate_app/presentation/widgets/CustomTextFormField.dart';
import 'package:easy_localization/easy_localization.dart';  // Import easy_localization

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if(CacheData.getData(key: AppCacheData.isAdmin) == true) {
            GoRouter.of(context).pushReplacement(AppRouter.kHomeView);
          } else {
            GoRouter.of(context).pushReplacement(AppRouter.KBLindHomeView);
          }
        } else if (state is LoginError) {
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
              inAsyncCall: state is LoginLoading,
              progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
              child: Padding(
                padding: const EdgeInsets.only(top: 75, left: 25, right: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       Center(
                        child: Text("login".tr(),  // Using easy_localization for translation
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Bahnschrift',
                                color: Color(0xff46325D),
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 60),
                      Customtextformfield(
                        controller: emailController,
                        label: "email".tr(),  // Using easy_localization for translation
                        hintText: "enter_email".tr(),  // Using easy_localization for translation
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 25),
                      Customtextformfield(
                        controller: passwordController,
                        label: "password".tr(),  // Using easy_localization for translation
                        hintText: "enter_password".tr(),  // Using easy_localization for translation
                        prefixIcon: Icons.lock_outline,
                        obscureText: !isPasswordVisible,
                        onSuffixIconTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushReplacement(AppRouter.kforgetPassword);
                        },
                        child: Text(
                          "forgot_password".tr(),  // Using easy_localization for translation
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Bahnschrift'),
                        ),
                      ),
                      const SizedBox(height: 75),
                      Custombottom(
                        text: "login".tr(),  // Using easy_localization for translation
                        onpressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<AuthCubit>().login(
                              email: emailController.text,
                              password: passwordController.text
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "dont_have_account".tr(),  // Using easy_localization for translation
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Bahnschrift'),
                          ),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context)
                                  .pushReplacement(AppRouter.kSignUp);
                            },
                            child: Text(
                              "sign_up".tr(),  // Using easy_localization for translation
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
