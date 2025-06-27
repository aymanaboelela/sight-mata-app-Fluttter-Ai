part of 'data_cubit.dart';

@immutable
abstract class DataState {}

class DataInitial extends DataState {}

class AddDataLoading extends DataState {}

class AddDataSuccess extends DataState {}
class UserTokenFound extends DataState {
  final UserTokenModel userToken;

  UserTokenFound({required this.userToken});
}
class AddDataError extends DataState {
  final String message;
  AddDataError({required this.message});
}

class GetDataLoading extends DataState {}

class GetDataEmpty extends DataState {}

class GetDataSuccess extends DataState {
  final List<DataModel> data;
  GetDataSuccess({required this.data});
}

class GetDataError extends DataState {
  final String message;
  GetDataError({required this.message});
}

class UpdateDataLoading extends DataState {}

class UpdateDataSuccess extends DataState {}

class UpdateDataError extends DataState {
  final String message;
  UpdateDataError({required this.message});
}
// حالات جديدة لحذف البيانات
class DeleteDataLoading extends DataState {}

class DeleteDataSuccess extends DataState {}

class DeleteDataError extends DataState {
  final String message;

  DeleteDataError({required this.message});
}
