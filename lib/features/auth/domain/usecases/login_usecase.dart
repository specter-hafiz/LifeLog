import 'package:dartz/dartz.dart';
import 'package:lifelog/core/error/failures.dart';
import 'package:lifelog/core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
