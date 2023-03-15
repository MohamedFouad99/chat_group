// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'register_cubit.dart';

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
