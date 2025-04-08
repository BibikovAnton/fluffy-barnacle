import 'package:dartz/dartz.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

import 'package:messanger/usecases/usecase.dart';

import '../entities/user_entities.dart';

class SignInWithEmailAndPassword implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInWithEmailAndPassword(this.repository);

  @override
  Future<Either<AuthFailure, UserEntity>> call(SignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}
