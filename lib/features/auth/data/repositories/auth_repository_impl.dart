import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/core/platform/network_info.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final Stream<UserEntity?> _authStateStream;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) : _authStateStream = remoteDataSource.authStateChanges();

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());

    try {
      final result = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return await result.fold((failure) => Left(failure), (user) async {
        await localDataSource.cacheUser(user);
        return Right(user);
      });
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure('Неизвестная ошибка'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());

    try {
      final result = await remoteDataSource.signUpWithEmailAndPassword(
        email,
        password,
        name,
      );
      return await result.fold((failure) => Left(failure), (user) async {
        await localDataSource.cacheUser(user);
        return Right(user);
      });
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure('Неизвестная ошибка'));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      final result = await remoteDataSource.signOut();
      if (result.isRight()) {
        await localDataSource.clearCache();
      }
      return result;
    } catch (e) {
      return Left(ServerFailure('Ошибка выхода'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) return Right(cachedUser);

      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(NetworkFailure());

      final result = await remoteDataSource.getCurrentUser();
      return await result.fold((failure) => Left(failure), (user) async {
        await localDataSource.cacheUser(user);
        return Right(user);
      });
    } catch (e) {
      return Left(ServerFailure('Ошибка получения пользователя'));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges => _authStateStream;

  @override
  Future<Either<AuthFailure, bool>> isSignedIn() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) return const Right(true);

      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return const Right(false);

      final result = await remoteDataSource.getCurrentUser();
      return result.fold((failure) => const Right(false), (user) async {
        await localDataSource.cacheUser(user);
        return const Right(true);
      });
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<AuthFailure, void>> sendPasswordResetEmail(String email) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка отправки email'));
    } catch (e) {
      return Left(ServerFailure('Неизвестная ошибка'));
    }
  }

  @override
  Future<Either<AuthFailure, void>> updateUserProfile({
    String? name,
    String? photoUrl,
    String? status,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return Left(UserNotLoggedInFailure());
      if (name != null) {
        await user.updateDisplayName(name);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      final updateData = <String, dynamic>{
        if (name != null) 'name': name,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (status != null) 'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updateData);

      final currentUser = await localDataSource.getCachedUser();
      if (currentUser != null) {
        await localDataSource.cacheUser(
          currentUser.copyWith(
            name: name ?? currentUser.name,
            photoUrl: photoUrl ?? currentUser.photoUrl,
            status: status ?? currentUser.status,
          ),
        );
      }

      @override
      Future<Either<AuthFailure, void>> updateUserProfile({
        String? name,
        String? photoUrl,
        String? status,
      }) async {
        final isConnected = await networkInfo.isConnected;
        if (!isConnected) return Left(NetworkFailure());

        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) return Left(UserNotLoggedInFailure());

          // Обновляем в Firebase Auth
          if (name != null) await user.updateDisplayName(name);
          if (photoUrl != null) await user.updatePhotoURL(photoUrl);

          // Обновляем в Firestore
          final updateData = <String, dynamic>{
            if (name != null) 'name': name,
            if (photoUrl != null) 'photoUrl': photoUrl,
            if (status != null) 'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update(updateData);

          return const Right(null);
        } on FirebaseException catch (e) {
          return Left(ServerFailure(e.message ?? 'Ошибка обновления профиля'));
        } catch (e) {
          return Left(ServerFailure('Неизвестная ошибка'));
        }
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ошибка обновления профиля'));
    } catch (e) {
      return Left(ServerFailure('Неизвестная ошибка'));
    }
  }
}
