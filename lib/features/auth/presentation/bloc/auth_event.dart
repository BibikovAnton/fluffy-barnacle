part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Событие инициализации (проверка текущего пользователя)
class AuthInitEvent extends AuthEvent {}

// Вход по email/паролю
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Регистрация
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? username;

  const AuthSignUpRequested(this.email, this.password, {this.username});

  @override
  List<Object?> get props => [email, password, username];
}

// Выход
class AuthSignOutRequested extends AuthEvent {}

// Получение текущего пользователя
class AuthGetCurrentUserRequested extends AuthEvent {}
