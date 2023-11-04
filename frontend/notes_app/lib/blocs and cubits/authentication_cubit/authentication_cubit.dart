import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/authentication/authentication.dart';
import 'package:notes_app/blocs%20and%20cubits/authentication_cubit/authentication_states.dart';
import 'package:notes_app/utils/shared_preferences_utils.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> signInWithGoogle() async {
    emit(AuthenticationLoading());
    Authentication authentication = Authentication();
    User? user = await authentication.signInWithGoogle();
    if (user != null) {
      await SharedPreferencesUtils.setCredentials(
          user.displayName!, user.email!, user.photoURL!);
      emit(UserAuthenticated());
    } else {
      emit(AuthenticationErrorState());
    }
  }
}
