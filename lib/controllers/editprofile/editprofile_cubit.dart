import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'editprofile_state.dart';

class EditprofileCubit extends Cubit<EditprofileState> {
  final supabase = Supabase.instance.client;

  EditprofileCubit() : super(EditprofileInitial());

  Future<void> updateProfile({
    String? newName,
    String? newPhone,
    String? newEmail,
    String? oldPassword,
    String? newPassword,
  }) async {
    emit(EditprofileLoading());

    try {
      await supabase.auth.signInWithPassword(
        email: CacheData.getData(key: emailChanged) ?? '',
        password: oldPassword!,
      );

      // إنشاء خريطة البيانات التي سيتم تحديثها
      Map<String, dynamic> updatedData = {};
      if (newName != null && newName.isNotEmpty) {
        updatedData["username"] = newName;
      }
      if (newPhone != null && newPhone.isNotEmpty) {
        updatedData["phone"] = newPhone;
      }

      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          email: newEmail?.isNotEmpty == true ? newEmail : null,
          data: updatedData.isNotEmpty ? updatedData : null,
          password: newPassword?.isNotEmpty == true ? newPassword : null,
        ),
      );

      final User? updatedUser = res.user;
      if (updatedUser != null) {
        log("Updated Email: ${updatedUser.email}");
      } else {
        log("User update failed or no user data returned.");
      }

      // تحديث القيم في الكاش إذا كانت غير null
      if (newName != null && newName.isNotEmpty) {
        CacheData.setData(key: userNameUser, value: newName);
      }
      if (newPhone != null && newPhone.isNotEmpty) {
        CacheData.setData(key: phoneCahnged, value: newPhone);
      }
      if (newEmail != null && newEmail.isNotEmpty) {
        CacheData.setData(key: emailChanged, value: newEmail);
      }

      emit(EditprofileSuccess());
    } catch (e) {
      log("Error updating profile: $e");
      emit(EditprofileError(message: "Error updating profile"));
    }
  }
}
