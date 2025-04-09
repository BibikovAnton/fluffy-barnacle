import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
