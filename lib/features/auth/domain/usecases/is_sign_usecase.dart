import 'package:dartz/dartz.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

class IsSignedIn {
  final AuthRepository repository;

  IsSignedIn(this.repository);

  Future<Either<AuthFailure, bool>> call() async {
    return await repository.isSignedIn();
  }
}
