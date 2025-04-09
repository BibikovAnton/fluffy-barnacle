import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

class SignUpWithEmailAndPassword {
  final AuthRepository repository;

  SignUpWithEmailAndPassword(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.signUpWithEmailAndPassword(email, password);
  }
}
