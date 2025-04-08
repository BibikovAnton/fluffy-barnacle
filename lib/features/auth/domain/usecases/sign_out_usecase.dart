import 'package:dartz/dartz.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<Either<AuthFailure, void>> call() async {
    return await repository.signOut();
  }
}
