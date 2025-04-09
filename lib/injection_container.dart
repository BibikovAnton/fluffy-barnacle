import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:messanger/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:messanger/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';
import 'package:messanger/features/auth/domain/usecases/get_current_user.dart';
import 'package:messanger/features/auth/domain/usecases/get_users.dart';
import 'package:messanger/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_up_usecases.dart';
import 'package:messanger/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Firebase
  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt(), getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SignInWithEmailAndPassword(getIt()));
  getIt.registerLazySingleton(() => SignUpWithEmailAndPassword(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));
  getIt.registerLazySingleton(() => GetUsers(getIt()));

  // BLoCs
  getIt.registerFactory(
    () => AuthBloc(
      signInWithEmailAndPassword: getIt(),
      signUpWithEmailAndPassword: getIt(),
      signOut: getIt(),
      getCurrentUser: getIt(),
    ),
  );
}
