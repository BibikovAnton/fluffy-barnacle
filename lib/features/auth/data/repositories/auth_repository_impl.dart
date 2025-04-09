import 'package:messanger/features/auth/data/models/user_model.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get user {
    return _remoteDataSource.user.map((firebaseUser) {
      return firebaseUser != null
          ? UserModel.fromFirestore(firebaseUser as Map<String, dynamic>)
              as UserEntity
          : null;
    });
  }

  @override
  UserEntity? get currentUser {
    final firebaseUser = _remoteDataSource.currentUser;
    return firebaseUser != null
        ? UserModel.fromFirestore(firebaseUser as Map<String, dynamic>)
            as UserEntity
        : null;
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final users = await _remoteDataSource.getAllUsers();
    return users.map((model) => model as UserEntity).toList();
  }

  @override
  Stream<List<UserEntity>> streamUsers() {
    return _remoteDataSource.streamUsers().map((models) {
      return models.map((model) => model as UserEntity).toList();
    });
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final user = await _remoteDataSource.signInWithEmailAndPassword(
      email,
      password,
    );
    return UserModel.fromFirestore(user as Map<String, dynamic>) as UserEntity;
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final user = await _remoteDataSource.signUpWithEmailAndPassword(
      email,
      password,
    );
    return UserModel.fromFirestore(user as Map<String, dynamic>) as UserEntity;
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }
}
