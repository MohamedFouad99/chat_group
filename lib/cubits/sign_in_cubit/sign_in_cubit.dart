// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
// [loginUser]: This method takes in two required string parameters: email and
// password. When this method is called, it emits a SignInLoading state, which
// indicates that thesign-in process is in progress.Then, it tries to sign in
// the user by calling the signInWithEmailAndPassword method of the FirebaseAuth
// class. If the user signs in successfully,the SignInSuccess state is emitted.
// If the sign-in process fails, the code catches the error thrown by Firebase
// and checks if the error code is user-not-found or wrong-password. Depending
// on the error, the SignInFailure state is emitted with an appropriate error
// message. If the error is not any of these, the SignInFailure state is
// emitted with the error message.
  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(SignInLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(SignInSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(SignInFailure(errorMessage: 'user-not-found'));
      } else if (ex.code == 'wrong-password') {
        emit(SignInFailure(errorMessage: 'wrong-password'));
      }
    } catch (e) {
      emit(SignInFailure(errorMessage: e.toString()));
    }
  }
}
