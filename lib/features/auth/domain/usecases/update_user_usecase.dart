import 'package:dartz/dartz.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

class UpdateUserProfile {
  final AuthRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<AuthFailure, void>> call(UpdateProfileParams params) async {
    return await repository.updateUserProfile(
      name: params.name,
      photoUrl: params.photoUrl,
      status: params.status,
    );
  }
}

class UpdateProfileParams {
  final String? name;
  final String? photoUrl;
  final String? status;

  UpdateProfileParams({this.name, this.photoUrl, this.status});
}
