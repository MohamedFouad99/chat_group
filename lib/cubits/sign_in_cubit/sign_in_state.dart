// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  String errorMessage;
  SignInFailure({
    required this.errorMessage,
  });
}
