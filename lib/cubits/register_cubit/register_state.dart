// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'register_cubit.dart';

// This code defines the different possible states of the registration process
// in a Flutter app, through the RegisterState abstract class and its subclasses:
// [RegisterInitial]: represents the initial state of the registration process,
// when the user hasn't taken any action yet.
// [RegisterLoading]: represents the state when the registration process is in
// progress, for example when the app is waiting for a response from a server or
// when an operation is being executed asynchronously.
// [RegisterSuccess]: represents the state when the registration process has been
// successfully completed.
// [PickedImageSuccess]: represents the state when an image has been successfully
// picked by the user during the registration process.
// [RegisterFailure]: represents the state when the registration process has failed,
// and includes an error message explaining the cause of the failure.
@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class PickedImageSuccess extends RegisterState {
  File? imageFile;
  PickedImageSuccess({
    this.imageFile,
  });
}

class RegisterFailure extends RegisterState {
  String errorMessage;
  RegisterFailure({
    required this.errorMessage,
  });
}
