import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messanger/core/auth/auth.dart';
import 'package:messanger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messanger/features/auth/presentation/pages/home_page.dart';
import 'package:messanger/features/auth/presentation/pages/login_page.dart';
import 'package:messanger/features/auth/presentation/pages/profile_page.dart';
import 'package:messanger/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<AuthBloc>()..add(AuthInitEvent()),
      child: MaterialApp(home: AuthPage()),
    );
  }
}
