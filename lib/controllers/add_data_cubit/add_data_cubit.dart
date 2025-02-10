import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_data_state.dart';

class AddDataCubit extends Cubit<AddDataState> {
  final supabase = Supabase.instance.client;

  AddDataCubit() : super(AddDataInitial());

  Future<void> addData({
    required String name,
    required String email,
    double? location,
  }) async {
    emit(AddDataLoading());

    try {
      // Get the current user from Supabase
      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(AddDataError(message: "User is not authenticated."));
        return;
      }

      // Insert data into a table (e.g., 'user_data')
      final response = await supabase.from('UsersData').insert({
        'userId': user.id,
        ' userName': name,
        'email': email,
        'location': location
      });

      if (response.error != null) {
        emit(AddDataError(
            message: "Error adding data: ${response.error?.message}"));
      } else {
        emit(AddDataSuccess());
      }
    } catch (e) {
      emit(AddDataError(message: "An unexpected error occurred"));
    }
  }
}
