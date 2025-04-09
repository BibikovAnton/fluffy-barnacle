import 'package:firebase_auth/firebase_auth.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';

import 'package:dartz/dartz.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  UserEntity? call() {
    return repository.currentUser;
  }
}
