import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/authentication_cubit/authentication_states.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> signInWithGoogle() async {
    emit(AuthenticationLoading());
  }
}
