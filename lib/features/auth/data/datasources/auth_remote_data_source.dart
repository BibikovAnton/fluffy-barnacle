import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';

abstract class AuthRemoteDataSource {
  Future<Either<AuthFailure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<AuthFailure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<Either<AuthFailure, void>> signOut();
  Future<Either<AuthFailure, UserEntity>> getCurrentUser();
  Stream<UserEntity?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(_userFromFirebase(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthError(e));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(_userFromFirebase(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthError(e));
    }
  }

  UserEntity _userFromFirebase(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email,
      name: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  AuthFailure _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return EmailAlreadyInUseFailure();
      case 'invalid-email':
      case 'wrong-password':
      case 'user-not-found':
        return InvalidEmailAndPasswordFailure();
      case 'user-disabled':
        return UserDisabledFailure();
      case 'weak-password':
        return WeakPasswordFailure();
      default:
        return ServerFailure(e.message ?? 'Ошибка аутентификации');
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await _auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка выхода из системы'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.email).get();
        final userData = doc.data();
        return Right(
          UserEntity(
            uid: user.uid,
            email: user.email,
            name: userData?['name'] ?? user.displayName,
            photoUrl: user.photoURL,
          ),
        );
      }
      return Left(UserNotLoggedInFailure());
    } catch (e) {
      return Left(ServerFailure('Ошибка получения пользователя'));
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _auth.authStateChanges().map(
      (user) => user != null ? _userFromFirebase(user) : null,
    );
  }
}
