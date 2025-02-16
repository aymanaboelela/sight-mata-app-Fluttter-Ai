import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/models/data_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final supabase = Supabase.instance.client;

  DataCubit() : super(DataInitial());

  Future<void> addData({
    required String name,
    required String email,
    double? distance,
    double? lat,
    double? lon,
  }) async {
    emit(AddDataLoading());

    try {
      await supabase.auth.refreshSession();

      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(AddDataError(message: "User is not authenticated."));
        return;
      }

      // إنشاء كائن من الموديل وتحويله إلى JSON
      DataModel userData = DataModel(
        userid: user.id,
        username: name,
        email: email,
        distance: distance,
        lat: lat,
        lon: lon,
      );

      await supabase.from('addusersdata').insert(userData.toJson());

      emit(AddDataSuccess());
    } catch (e) {
      log("Error adding data: ${e.toString()}");
      emit(AddDataError(message: e.toString()));
    }
  }

  Future<List<DataModel>> getData() async {
    emit(GetDataLoading());
    await supabase.auth.refreshSession();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(GetDataError(message: "User is not authenticated."));
      }

      final response =
          await supabase.from('addusersdata').select().eq('userid', user!.id);

      if (response.isEmpty) {
        emit(GetDataEmpty());
        return []; // إرجاع null بدلاً من قيمة غير معروفة
      } else {
        // تحويل البيانات من JSON إلى `DataModel`
        List<DataModel> dataList =
            response.map((json) => DataModel.fromJson(json)).toList();

        log("Data retrieved successfully: $dataList");

        emit(GetDataSuccess(data: dataList));

        return dataList; // إرجاع أول عنصر في القائمة
      }
    } catch (e) {
      log("Error retrieving data: ${e.toString()}");
      emit(GetDataError(message: e.toString()));

      return [];
    }
  }

  Future<void> updateData({
    String? name,
    String? email,
    double? distance,
    double? lat,
    double? lon,
  }) async {
    emit(UpdateDataLoading());

    try {
      // تأكد من تحديث الجلسة بشكل صحيح
      final sessionResponse = await supabase.auth.refreshSession();
      log("Session refreshed: ${sessionResponse.toString()}");

      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(UpdateDataError(message: "User is not authenticated."));
        return;
      }

      log("User authenticated: ${user.id}");
      DataModel userData = DataModel(
        userid: user.id,
        username: name!,
        email: email!,
        distance: distance,
        lat: lat,
        lon: lon,
      );
      // تحديث البيانات في قاعدة البيانات
      final response = await supabase
          .from('addusersdata')
          .update(userData.toJson())
          .eq('userid', user.id) // التأكد من التحديث بناءً على الـ userid
          .select();
      getData();
      log("Response from Supabase: ${response.toString()}");
      emit(UpdateDataSuccess());
    } catch (e) {
      log("Error updating data: ${e.toString()}");
      emit(UpdateDataError(message: e.toString()));
    }
  }
}
