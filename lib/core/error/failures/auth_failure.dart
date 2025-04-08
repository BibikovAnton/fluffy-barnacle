import 'package:equatable/equatable.dart';

abstract class AuthFailure extends Equatable {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Конкретные реализации ошибок
class ServerFailure extends AuthFailure {
  const ServerFailure(String message) : super(message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Email уже используется');
}

class InvalidEmailAndPasswordFailure extends AuthFailure {
  const InvalidEmailAndPasswordFailure() : super('Неверный email или пароль');
}

class UserDisabledFailure extends AuthFailure {
  const UserDisabledFailure() : super('Пользователь заблокирован');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Слабый пароль');
}

class UserNotLoggedInFailure extends AuthFailure {
  const UserNotLoggedInFailure() : super('Пользователь не авторизован');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure() : super('Нет подключения к интернету');
}
