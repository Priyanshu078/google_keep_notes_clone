import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/authentication/authentication.dart';
import 'package:notes_app/blocs%20and%20cubits/authentication_cubit/authentication_states.dart';
import 'package:notes_app/utils/shared_preferences_utils.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final Authentication authentication = Authentication();

  Future<void> signInWithGoogle() async {
    emit(AuthenticationLoading());
    User? user = await authentication.signInWithGoogle();
    if (user != null) {
      await SharedPreferencesUtils.setCredentials(
          user.displayName!, user.email!, user.photoURL!);
      SharedPreferencesUtils.name = user.displayName!;
      SharedPreferencesUtils.email = user.email!;
      SharedPreferencesUtils.imageUrl = user.photoURL!;
      emit(UserAuthenticated());
    } else {
      emit(AuthenticationErrorState());
    }
  }

  Future<void> signOutWithGoogle() async {
    emit(AuthenticationLoading());
    try {
      await authentication.signOut();
      await SharedPreferencesUtils.clearData();
      emit(AuthenticationInitial());
    } catch (e) {
      if (kDebugMode) {
        print(e);
        emit(AuthenticationErrorState());
      }
    }
  }
}
