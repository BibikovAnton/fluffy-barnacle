part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  final UserEntity? user;
  final String? error;

  const AuthState({this.user, this.error});

  @override
  List<Object?> get props => [user, error];
}

// Начальное состояние
class AuthInitial extends AuthState {
  const AuthInitial() : super();
}

// Загрузка
class AuthLoading extends AuthState {
  const AuthLoading() : super();
}

// Успешная аутентификация
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(UserEntity user) : super(user: user);
}

// Не аутентифицирован
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({String? error}) : super(error: error);
}

// Ошибка
class AuthError extends AuthState {
  const AuthError(String error) : super(error: error);
}
