import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/usecases/get_current_user.dart';
import 'package:messanger/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_up_usecases.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPassword signInWithEmailAndPassword;
  final SignUpWithEmailAndPassword signUpWithEmailAndPassword;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.signInWithEmailAndPassword,
    required this.signUpWithEmailAndPassword,
    required this.signOut,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<AuthInitEvent>(_onInit);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthGetCurrentUserRequested>(_onGetCurrentUserRequested);
  }

  Future<void> _onInit(AuthInitEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _tryGetCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Authentication failed'));
      emit(AuthUnauthenticated(error: e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated(error: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signUpWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Registration failed'));
      emit(AuthUnauthenticated(error: e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated(error: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onGetCurrentUserRequested(
    AuthGetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = await _tryGetCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<UserEntity?> _tryGetCurrentUser() async {
    try {
      return getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    // Закрываем все подписки здесь при необходимости
    return super.close();
  }
}
