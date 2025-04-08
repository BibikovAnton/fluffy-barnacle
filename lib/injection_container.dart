import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:messanger/core/platform/network_info.dart';
import 'package:messanger/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:messanger/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:messanger/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:messanger/features/auth/domain/repositories/user_repositories.dart';
import 'package:messanger/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_up_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:messanger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // Firebase services
//   sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
//   sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

//   // Data sources
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerLazySingleton(() => sharedPreferences);

//   // Use cases
//   sl.registerLazySingleton(() => GetCurrentUser(sl()));
//   sl.registerLazySingleton(() => SignInWithEmailAndPassword(sl()));
//   sl.registerLazySingleton(() => SignUpWithEmailAndPassword(sl()));
//   sl.registerLazySingleton(() => SignOut(sl()));
//   sl.registerLazySingleton(() => UpdateUserProfile(sl()));

//   // Repositories
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(
//       remoteDataSource: sl(),
//       localDataSource: sl(),
//       networkInfo: sl(),
//     ),
//   );

//   // Data sources implementations
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(firestore: sl(), auth: sl()),
//   );

//   sl.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(sl()),
//   );

//   // Core
//   sl.registerLazySingleton<NetworkInfo>(
//     () => NetworkInfoImpl(connectionChecker: sl(), connectivity: sl()),
//   );

//   // External
//   sl.registerLazySingleton(() => ());
//   sl.registerLazySingleton(() => Connectivity());

//   // Bloc
//   sl.registerFactory(
//     () => AuthBloc(
//       signInWithEmailAndPassword: sl(),
//       signOut: sl(),
//       signUpWithEmailAndPassword: sl(),
//       getCurrentUser: sl(),
//       updateUserProfile: sl(),
//     ),
//   );
// }
