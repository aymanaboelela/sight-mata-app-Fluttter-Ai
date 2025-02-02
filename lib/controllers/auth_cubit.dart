import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final supabase = Supabase.instance.client;
  Future<void> createAccount(
      {required String email,
      required String password,
      required String userName,
      required String phone}) async {
    emit(CreateLoading());
    try {
      await supabase.auth.signUp(
        phone: phone,
        data: {"username": userName},

      
        email: email,
        password: password,
      );
      emit(CreateSuccess());
    } on Exception catch (e) {
      emit(CreateError(message: e.toString()));
    } catch (e) {
      emit(CreateError(message: e.toString()));
    }
  }

  // Future<void> verifyOtp({
  //   String? email,
  //   String? phone,
  //   required String token,
  //   required OtpType type,
  // }) async {
  //   emit(OTPVerificationLoading());
  //   try {
  //     await supabase.auth.verifyOTP(
  //       email: email,
  //       phone: phone,
  //       token: token,
  //       type: type,
  //     );
  //     emit(LoginSuccess()); // Assuming successful verification logs user in
  //   } on AuthException catch (e) {
  //     emit(OTPVerificationError(message: e.message));
  //   } catch (e) {
  //     emit(OTPVerificationError(message: e.toString()));
  //   }
  // }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on Exception catch (e) {
      emit(LoginError(message: e.toString()));
    } catch (e) {
      emit(LoginError(message: e.toString()));
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
  // Future<void> checkAuth() async {
  //   final user = supabase.auth.currentUser;
  //   if (user != null) {
  //     emit(LoginSuccess());
  //   } else {
  //     emit(AuthInitial());
  //   }
  // }
}
