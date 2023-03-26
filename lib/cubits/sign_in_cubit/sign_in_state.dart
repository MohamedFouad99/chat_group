// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'sign_in_cubit.dart';

// This code defines a set of state classes used in the SignInCubit, which is
// responsible for handling sign-in functionality.
// SignInInitial: represents the initial state of the sign-in process
// SignInLoading: represents the loading state while waiting for the sign-in to complete
// SignInSuccess: represents the state when the sign-in is successful
// SignInFailure: represents the state when the sign-in fails, and contains an
// error message to be displayed to the user.
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
