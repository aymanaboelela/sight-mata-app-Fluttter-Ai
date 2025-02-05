import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/CustomButton.dart';
import 'package:sight_mate_app/presentation/widgets/CustomTextFormField.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  bool isPasswordVisible = false; // variable for password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 75, left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Center(
                child: Text("Log in",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Bahnschrift',
                        color: Color(0xff00487C),
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 60,
              ),
              const Customtextformfield(
                label: "Email",
                hintText: "Enter your email",
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(
                height: 25,
              ),
              Customtextformfield(
                  label: "Password",
                  hintText: "Enter a password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: !isPasswordVisible,
                  onSuffixIconTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  }),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "forget Password?",
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: 'Bahnschrift'),
              ),
              const SizedBox(
                height: 75,
              ),
              Custombottom(
                text: "Log in",
                onpressed: () {
                   GoRouter.of(context)
                            .pushReplacement(AppRouter.kHomeView);
                },
              ),
              const SizedBox(
                height: 20,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Bahnschrift'),
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context)
                            .pushReplacement(AppRouter.kSignUp);
                    },
                    child:const Text(
                      "Sign up",
                      style: TextStyle(
                          color: Color(0xff00487C),
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
    );
  }
}
