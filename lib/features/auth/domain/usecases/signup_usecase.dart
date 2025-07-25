import 'package:dartz/dartz.dart';
import 'package:lifelog/core/error/failures.dart';
import 'package:lifelog/core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Signup implements UseCase<User, SignupParams> {
  final AuthRepository repository;

  Signup(this.repository);

  @override
  Future<Either<Failure, User>> call(SignupParams params) {
    return repository.signup(params.email, params.password);
  }
}

class SignupParams {
  final String email;
  final String password;

  SignupParams({required this.email, required this.password});
}
