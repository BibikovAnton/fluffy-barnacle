import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:messanger/core/error/failures/auth_failure.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:messanger/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_up_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/update_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPassword signInWithEmailAndPassword;
  final SignUpWithEmailAndPassword signUpWithEmailAndPassword;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final UpdateUserProfile updateUserProfile;

  AuthBloc({
    required this.signInWithEmailAndPassword,
    required this.signUpWithEmailAndPassword,
    required this.signOut,
    required this.getCurrentUser,
    required this.updateUserProfile,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithEmailAndPassword(
      SignInParams(email: event.email, password: event.password),
    );

    _handleAuthResult(result, emit);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpWithEmailAndPassword(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    _handleAuthResult(result, emit);
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signOut();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCurrentUser();

    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! Authenticated) return;

    emit(AuthLoading());
    final currentUser = (state as Authenticated).user;

    final result = await updateUserProfile(
      UpdateProfileParams(
        name: event.name,
        photoUrl: event.photoUrl,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(
        ProfileUpdated(
          currentUser.copyWith(
            name: event.name ?? currentUser.name,
            photoUrl: event.photoUrl ?? currentUser.photoUrl,
            status: event.status ?? currentUser.status,
          ),
        ),
      ),
    );
  }

  void _handleAuthResult(
    Either<AuthFailure, UserEntity> result,
    Emitter<AuthState> emit,
  ) {
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Stream<UserEntity?> get userStream {
    return stream
        .where((state) => state is Authenticated || state is ProfileUpdated)
        .map((state) {
          if (state is Authenticated) return state.user;
          if (state is ProfileUpdated) return state.user;
          return null;
        });
  }
}
