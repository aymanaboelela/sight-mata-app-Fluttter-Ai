import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart';
import 'package:sight_mate_app/presentation/widgets/BlueButton.dart'; 
import 'package:sight_mate_app/core/constants/colors.dart'; 
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final resetTokenC = TextEditingController();
  bool _passwordVisible = true;
  bool? isLoading;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reset_password'.tr()), // Localized title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset Token Field
              TextFormField(
                controller: resetTokenC,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'reset_token'.tr(), // Localized hint text
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'token_invalid'.tr(); // Localized error
                  }
                  return null;
                },
              ),
              formSpacer,
              // Email Field
              TextFormField(
                controller: emailC,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'email'.tr(), // Localized hint text
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => !EmailValidator.validate(value!)
                    ? 'email_invalid'.tr() // Localized error
                    : null,
              ),
              formSpacer,
              // Password Field
              TextFormField(
                controller: passwordC,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'new_password'.tr(), // Localized hint text
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: _passwordVisible
                        ? Icon(Icons.visibility_off, color: Colors.grey)
                        : Icon(Icons.visibility, color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'password_invalid'.tr(); // Localized error
                  }
                  return null;
                },
              ),
              formSpacer,
              // Reset Password Button
              BlueButton(
                teks: 'reset_password_button'.tr(), // Localized button text
                padding: 0,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Center(child: CircularProgressIndicator()),
                    );
                    try {
                      // Calling the Cubit's method for OTP verification and password update
                      await context.read<AuthCubit>().resetPasswordWithOTP(
                            email: emailC.text,
                            resetToken: resetTokenC.text,
                            newPassword: passwordC.text,
                          );
                    } catch (e) {
                      // If an error occurs, display the error message
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text('An error occurred: ${e.toString()}'),
                        ),
                      );
                    } finally {
                      isLoading = false;
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('fill_fields'.tr())), // Localized message
                    );
                  }
                },
              ),
              formSpacer,
              // BlocConsumer to handle the success or failure messages
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ResetPasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('password_reset_success'.tr())), // Localized success message
                    );
                  } else if (state is ResetPasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message ?? 'password_reset_error'.tr())), // Localized error message
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ResetPasswordLoading) {
                    return const CircularProgressIndicator(); // Loading indicator
                  }
                  return Container();
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
