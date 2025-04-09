import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

class GetUsers {
  final AuthRepository repository;

  GetUsers(this.repository);

  Future<List<UserEntity>> call() async => await repository.getAllUsers();
}
