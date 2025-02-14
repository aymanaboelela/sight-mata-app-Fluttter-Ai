part of 'editprofile_cubit.dart';

@immutable
abstract class EditprofileState {}

class EditprofileInitial extends EditprofileState {}

class EditprofileLoading extends EditprofileState {}

class EditprofileSuccess extends EditprofileState {}

class EditprofileError extends EditprofileState {
  final String message;
  EditprofileError({required this.message});
}
