import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart'; // Add email validation library
import 'package:flutter_bloc/flutter_bloc.dart'; // Add Bloc library
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart'; // Import AuthCubit
import 'package:sight_mate_app/core/constants/colors.dart'; // Import colors
import 'package:sight_mate_app/presentation/screens/reset_pass.dart'; // Import ResetPassword screen
import 'package:sight_mate_app/presentation/widgets/BlueButton.dart'; // Import BlueButton widget

// Forgot Password Screen
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email field
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'Email',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => !EmailValidator.validate(value!)
                    ? 'Invalid email format!' // Email validation
                    : null,
              ),
              formSpacer,
              // Send token button
              BlueButton(
                teks: 'Send Reset Password Token',
                padding: 0,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Container(
                          child: const Text(
                            'Please check your email and spam folder for the token if it\'s not in your inbox!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                    // Call resetPassword method from AuthCubit
                    context.read<AuthCubit>().resetPassword(email: emailC.text);
                  } else {
                    null;
                  }
                },
              ),
              formSpacer,
              // Button to navigate to ResetPassword page
              TextButton(
                child: const Text('Already have a token? Reset your password'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPassword(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const formSpacer = SizedBox(width: 16, height: 16);
const borderRadiusStd = BorderRadius.all(Radius.circular(8));
