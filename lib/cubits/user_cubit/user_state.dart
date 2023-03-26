part of 'user_cubit.dart';

// UserSuccess is the state that represents a successful retrieval of user data.
// It contains three lists: names, emails, and photos, which respectively hold
// the display names, emails, and photo URLs of the users. The lists are passed
// to UserSuccess as parameters when it is constructed.
@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserSuccess extends UserState {
  final List<String> names;
  final List<String> emails;
  final List<String> photos;

  UserSuccess(this.names, this.emails, this.photos);
}
