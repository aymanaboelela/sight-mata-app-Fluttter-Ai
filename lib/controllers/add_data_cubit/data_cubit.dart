import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

import 'package:sight_mate_app/models/data_mode.dart';
import 'package:sight_mate_app/models/user_token_model.dart';
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
        return []; 
      } else {
       
        List<DataModel> dataList =
            response.map((json) => DataModel.fromJson(json)).toList();

        log("Data retrieved successfully: $dataList");

        emit(GetDataSuccess(data: dataList));

        return dataList; 
      }
    } catch (e) {
      log("Error retrieving data: ${e.toString()}");
      emit(GetDataError(message: e.toString()));

      return [];
    }
  }

  Future<void> updateData({
    required String id,
    String? name,
    String? email,
    double? distance,
    double? lat,
    double? lon,
  }) async {
    emit(UpdateDataLoading());

    try {

      final sessionResponse = await supabase.auth.refreshSession();
      log("Session refreshed: ${sessionResponse.toString()}");

      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(UpdateDataError(message: "User is not authenticated."));
        return;
      }

      log("User authenticated: ${user.id}");
      DataModel userData = DataModel(
        id: id,
        userid: user.id,
        username: name!,
        email: email!,
        distance: distance,
        lat: lat,
        lon: lon,
      );
     
      final response = await supabase
          .from('addusersdata')
          .update(userData.toJson())
          .eq('id', id)
          .select();
      getData();
      log("Response from Supabase: ${response.toString()}");
      emit(UpdateDataSuccess());
    } catch (e) {
      log("Error updating data: ${e.toString()}");
      emit(UpdateDataError(message: e.toString()));
    }
  }


  Future<List<LatLng>> getAllUsersWithLatLon() async {
    emit(GetDataLoading());

    try {
     
      await supabase.auth.refreshSession();

     
      final response = await supabase
          .from('addusersdata')
          .select()
          .not('lat', 'is', null)
          .not('lon', 'is', null); 

      if (response.isEmpty) {
        emit(GetDataEmpty());
        return [];
      } else {
    
        List<LatLng> latLngList = response.map((json) {
          var lat = json['lat'];
          var lon = json['lon'];

      
          if (lat != null && lon != null) {
            return LatLng(lat.toDouble(),
                lon.toDouble()); 
          } else {
            return LatLng(
                0.0, 0.0); 
          }
        }).toList();

        log("Data retrieved successfully: $latLngList");

        return latLngList; 
      }
    } catch (e) {
      log("Error retrieving data: ${e.toString()}");
      emit(GetDataError(message: e.toString()));
      return [];
    }
  }

  Future<void> deleteData({required String id}) async {
    emit(DeleteDataLoading());

    try {
      await supabase.auth.refreshSession();
      await supabase.from('addusersdata').delete().eq('id', id);

      getData();
      emit(DeleteDataSuccess());
    } catch (e) {
      log("Error deleting data: ${e.toString()}");
      emit(DeleteDataError(message: e.toString()));
    }
  }

  Future<void> deleteObject({required String id}) async {
    emit(DeleteDataLoading());

    try {
      await supabase.auth.refreshSession();
      await supabase.from('addusersdata').delete().eq('id', id);

      getData();
      emit(DeleteDataSuccess());
    } catch (e) {
      log("Error deleting object: ${e.toString()}");
      emit(DeleteDataError(message: e.toString()));
    }
  }
  Future<void> checkEmailAndFetchToken({
  required String email,
}) async {
  try {
    final response = await supabase
        .from('user_tokens')
        .select()
        .eq('id', email)
        .maybeSingle(); 

    if (response == null) {
      emit(AddDataError(message: "❌ Email not found in user_tokens."));
      return;
    }

    final userToken = UserTokenModel.fromJson(response);

    log("✅ Found user token: ${userToken.fcmToken}, user_type: ${userToken.userType}");

    
    emit(UserTokenFound(userToken: userToken));
  } catch (e) {
    log("❌ Error fetching user token: ${e.toString()}");
    emit(AddDataError(message: e.toString()));
  }
}

}
