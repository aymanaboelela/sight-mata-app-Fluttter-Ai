part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
// create acount

class CreateSuccess extends AuthState {}

class CreateLoading extends AuthState {}

class CreateError extends AuthState {
  final String message;
  CreateError({required this.message});
}

// login
class LoginSuccess extends AuthState {}

class LoginLoading extends AuthState {}

class LoginError extends AuthState {
  final String message;
  LoginError({required this.message});
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordError extends AuthState {
  final String message;
  ResetPasswordError({required this.message});
}

