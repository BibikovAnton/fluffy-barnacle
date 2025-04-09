import 'package:messanger/features/auth/domain/entities/user_entities.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get user;
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  UserEntity? get currentUser;
  Future<List<UserEntity>> getAllUsers();
  Stream<List<UserEntity>> streamUsers();
}
