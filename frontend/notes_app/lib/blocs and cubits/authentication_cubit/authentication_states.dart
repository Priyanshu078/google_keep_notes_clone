import 'package:equatable/equatable.dart';

class AuthenticationStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationStates {}

class AuthenticationLoading extends AuthenticationStates {}

class UserAuthenticated extends AuthenticationStates {}

class AuthenticationErrorState extends AuthenticationStates {}
