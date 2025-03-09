import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sight_mate_app/core/constants/cach_data_const.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final supabase = Supabase.instance.client;
  Future<void> createAccount({
    required String email,
    required String password,
    required String userName,
    required String phone,
    required bool isAdmin,
  }) async {
    emit(CreateLoading());

    try {
      final AuthResponse response = await supabase.auth.signUp(
        data: {
          "username": userName,
          "phone": phone,
          "is_admin": isAdmin,
        },
        email: email,
        password: password,
      );

      if (response.user != null) {
        emit(CreateSuccess());
      } else {
        emit(CreateError(message: "Unknown error occurred during signup"));
      }
    } on AuthException catch (e) {
      log("create account the error is **** ${e.message}");

      if (e.message.contains("User already registered")) {
        emit(CreateError(message: "This email is already registered"));
      } else if (e.message.contains("password")) {
        emit(CreateError(
            message: "Weak password, please choose a stronger one"));
      } else if (e.message.contains("Invalid email")) {
        emit(CreateError(message: "Invalid email format"));
      } else if (e.message.contains("phone number")) {
        emit(CreateError(message: "This phone number is already in use"));
      } else {
        emit(CreateError(message: e.message));
      }
    } catch (e) {
      log("create account the error is **** $e");
      emit(CreateError(message: "An unexpected error occurred"));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        emit(LoginSuccess());
      } else {
        emit(LoginError(message: "Login failed. Please try again."));
      }
      CacheData.setData(
          key: userNameUser, value: response.user?.userMetadata?['username']);
      CacheData.setData(
          key: phoneCahnged, value: response.user?.userMetadata?['phone']);
      CacheData.setData(
          key: AppCacheData.isAdmin,
          value: response.user?.userMetadata?["is_admin"]);
      CacheData.setData(key: emailChanged, value: email);
    } on AuthException catch (e) {
      log("login the error is **** ${e.message}");

      if (e.message.contains("Invalid login credentials")) {
        emit(LoginError(
            message: "Incorrect email or password. Please try again."));
      } else if (e.message.contains("Email not confirmed")) {
        emit(LoginError(
            message: "Your email is not confirmed. Please check your inbox."));
      } else if (e.message.contains("User not found")) {
        emit(LoginError(message: "No account found with this email."));
      } else if (e.message.contains("Too many requests")) {
        emit(LoginError(
            message: "Too many failed attempts. Please wait and try again."));
      } else if (e.message.contains("Auth session missing")) {
        emit(LoginError(
            message:
                "Authentication session is missing. Please log in again."));
      } else {
        emit(LoginError(message: e.message));
      }
    } catch (e) {
      log("login the error is **** $e");
      emit(LoginError(message: "An unexpected error occurred."));
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoading());
    try {
      await supabase.auth.resetPasswordForEmail(email);
      emit(ResetPasswordSuccess());
    } on Exception catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }

  Future<void> resetPasswordWithOTP({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    try {
      // Verify the OTP (token) to confirm the reset process
      final recovery = await supabase.auth.verifyOTP(
        
        email: email,
        token: resetToken,
        type: OtpType.recovery, // Type: recovery
      );

      print("OTP verification result: $recovery");

      // Update the password for the user
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      emit(ResetPasswordSuccess());
    } on AuthException catch (e) {
      emit(ResetPasswordError(message: e.message));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }
}
