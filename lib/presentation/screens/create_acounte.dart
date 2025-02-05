import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/CustomButton.dart';
import 'package:sight_mate_app/presentation/widgets/CustomTextFormField.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupView> {
  bool isPasswordVisible = false; // variable for password visibility

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Text("Sign Up",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Bahnschrift',
                        color: Color(0xff00487C),
                        fontWeight: FontWeight.bold)),
              ),
             const SizedBox(
                height: 30,
              ),
             const Customtextformfield(
                label: "Name",
                hintText: "Enter your name",
                prefixIcon: Icons.person_2_outlined,
              ),
             const SizedBox(
                height: 30,
              ),
             const Customtextformfield(
                label: "Phone Number",
                hintText: "Enter your phone",
                prefixIcon: Icons.lock_outlined,
              ),
            const  SizedBox(
                height: 30,
              ),
             const Customtextformfield(
                label: "Email",
                hintText: "Enter your email",
                prefixIcon: Icons.email_outlined,
              ),
             const SizedBox(
                height: 30,
              ),
              Customtextformfield(
                label: "Password",
                hintText: "Enter your password",
                prefixIcon: Icons.lock_outlined,
                obscureText: !isPasswordVisible,
                onSuffixIconTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Customtextformfield(
                label: "Verify Password",
                hintText: "Enter your password",
                prefixIcon: Icons.lock_outlined,
                 obscureText: !isPasswordVisible,
                onSuffixIconTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 50,),
              Custombottom(text: "Create Account", onpressed: (){
                 GoRouter.of(context)
                            .pushReplacement(AppRouter.kHomeView);
              }),
              SizedBox(height: 25,),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Alreadyhave an account ?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Bahnschrift'),
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context)
                            .pushReplacement(AppRouter.kLoginView);
                    },
                    child:const Text(
                      "login",
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
