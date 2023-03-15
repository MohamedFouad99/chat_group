part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserSuccess extends UserState {
  final List<String> names;
  final List<String> emails;
  final List<String> photos;

  UserSuccess(this.names, this.emails, this.photos);
}
