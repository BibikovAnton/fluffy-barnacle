// Базовый use case
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:messanger/core/error/failures/auth_failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<AuthFailure, Type>> call(Params params);
}

// Для use case'ов без параметров
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
