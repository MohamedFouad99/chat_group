// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

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
