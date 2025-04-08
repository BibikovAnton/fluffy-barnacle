import 'package:dartz/dartz.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';

abstract class AuthRepository {
  // Email & Password
  Future<Either<AuthFailure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<AuthFailure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );

  Future<Either<AuthFailure, void>> sendPasswordResetEmail(String email);

  // Текущий пользователь
  Future<Either<AuthFailure, UserEntity>> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;

  // Выход
  Future<Either<AuthFailure, void>> signOut();

  // Проверка состояния аутентификации
  Future<Either<AuthFailure, bool>> isSignedIn();

  // Обновление профиля
  Future<Either<AuthFailure, void>> updateUserProfile({
    String? name,
    String? photoUrl,
    String? status,
  });
}
