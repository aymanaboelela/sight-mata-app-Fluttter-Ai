import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sight_mate_app/controllers/auth/auth_cubit.dart';
import 'package:sight_mate_app/presentation/widgets/BlueButton.dart'; // استيراد زر BlueButton
import 'package:sight_mate_app/core/constants/colors.dart'; // استيراد الألوان

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
        title: const Text('Reset Password'),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'Reset Token',
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Invalid token!';
                  }
                  return null;
                },
              ),
              formSpacer,
              // Email Field
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'Email',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => !EmailValidator.validate(value!)
                    ? 'Invalid email format!'
                    : null,
              ),
              formSpacer,
              // Password Field
              TextFormField(
                controller: passwordC,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'New Password',
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
                    return 'Password must be at least 6 characters!';
                  }
                  return null;
                },
              ),
              formSpacer,
              // Reset Password Button
              BlueButton(
                teks: 'Reset Password',
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
                      const SnackBar(content: Text('Please fill in the fields correctly!')),
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
                      const SnackBar(content: Text('Password reset successful. Please log in again.')),
                    );
                  } else if (state is ResetPasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message ?? 'An error occurred')),
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
