import 'package:equatable/equatable.dart';
import 'package:lifelog/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailureState extends AuthState {
  final String message;

  AuthFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
