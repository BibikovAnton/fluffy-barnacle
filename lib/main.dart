import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:messanger/core/auth/auth.dart';
import 'package:messanger/core/platform/network_info.dart';
import 'package:messanger/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:messanger/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:messanger/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:messanger/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:messanger/features/auth/domain/usecases/sign_up_usecases.dart';
import 'package:messanger/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:messanger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messanger/firebase_options.dart';
//import 'package:messanger/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Создаем экземпляры зависимостей "снизу вверх"
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final sharedPreferences = await SharedPreferences.getInstance();

  // DataSources
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    auth: firebaseAuth,
    firestore: firestore,
  );
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences);

  // Repository
  final connectionChecker = InternetConnectionChecker.createInstance();
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
    networkInfo: NetworkInfoImpl(
      connectionChecker: connectionChecker,
      connectivity: Connectivity(),
    ),
  );

  // UseCases
  final signInUseCase = SignInWithEmailAndPassword(authRepository);
  final signUpUseCase = SignUpWithEmailAndPassword(authRepository);
  final signOutUseCase = SignOut(authRepository);
  final getCurrentUserUseCase = GetCurrentUser(authRepository);
  final updateProfileUseCase = UpdateUserProfile(authRepository);

  // Создаем Bloc со всеми зависимостями
  final authBloc = AuthBloc(
    signInWithEmailAndPassword: signInUseCase,
    signUpWithEmailAndPassword: signUpUseCase,
    signOut: signOutUseCase,
    getCurrentUser: getCurrentUserUseCase,
    updateUserProfile: updateProfileUseCase,
  );

  // Запускаем приложение с передачей зависимостей
  runApp(MessengerApp(authBloc: authBloc));
}

class MessengerApp extends StatelessWidget {
  final AuthBloc authBloc;

  const MessengerApp({Key? key, required this.authBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: MaterialApp(title: 'Messenger', home: AuthPage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(LogoutEvent()),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Добро пожаловать, ${user.name ?? "Пользователь"}!'),
                  const SizedBox(height: 20),
                  Text(user.email ?? ''),
                ],
              ),
            );
          }
          return Text('!!!');
        },
      ),
    );
  }
}
