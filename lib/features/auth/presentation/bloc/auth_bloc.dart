import 'package:bloc/bloc.dart';
import 'package:lifelog/core/usecases/usecase.dart';
import 'package:lifelog/features/auth/domain/usecases/get_current_user.dart';
import 'package:lifelog/features/auth/domain/usecases/login_usecase.dart';
import 'package:lifelog/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lifelog/features/auth/domain/usecases/signup_usecase.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_event.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;
  final Signup signupUsecase;
  final Logout logoutUsecase;
  final GetCurrentUser getCurrentUserUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.signupUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUserUsecase(NoParams());

    result.fold((failure) => emit(AuthUnauthenticated()), (user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );
    print("Login Result: $result");
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signupUsecase(
      SignupParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailureState(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUsecase(NoParams());
    result.fold(
      (failure) => emit(AuthFailureState(failure.toString())),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
