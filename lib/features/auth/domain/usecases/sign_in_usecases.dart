import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

class SignInWithEmailAndPassword {
  final AuthRepository repository;

  SignInWithEmailAndPassword(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.signInWithEmailAndPassword(email, password);
  }
}
