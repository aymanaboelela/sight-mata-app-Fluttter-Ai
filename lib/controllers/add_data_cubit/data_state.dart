part of 'data_cubit.dart';

@immutable
abstract class DataState {}

class DataInitial extends DataState {}

class AddDataLoading extends DataState {}

class AddDataSuccess extends DataState {}

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
