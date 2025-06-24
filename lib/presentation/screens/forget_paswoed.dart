import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart'; // Add email validation library
import 'package:flutter_bloc/flutter_bloc.dart'; // Add Bloc library
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart'; // Import AuthCubit
import 'package:sight_mate_app/core/constants/colors.dart'; // Import colors
import 'package:sight_mate_app/presentation/screens/reset_pass.dart'; // Import ResetPassword screen
import 'package:sight_mate_app/presentation/widgets/BlueButton.dart'; // Import BlueButton widget
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

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
        title: Text('forgot_password'.tr()), // Translated title
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'email'.tr(), // Translated hint text
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => !EmailValidator.validate(value!)
                    ? 'invalid_email_format'.tr() // Translated validation error
                    : null,
              ),
              formSpacer,
              // Send token button
              BlueButton(
                teks: 'send_reset_password_token'.tr(), // Translated button text
                padding: 0,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Container(
                          child: Text(
                            'check_email'.tr(), // Translated dialog message
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
                child: Text('already_have_token'.tr()), // Translated button text
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
