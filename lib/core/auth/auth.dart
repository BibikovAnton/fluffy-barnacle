import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messanger/core/auth/login_or_register.dart';

import 'package:messanger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messanger/features/auth/presentation/pages/home_page.dart';
import 'package:messanger/features/auth/presentation/widgets/loading_widget.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingWidget();
        } else if (state is AuthAuthenticated) {
          return const HomePage();
        } else {
          return const LoginOrRegister();
        }
      },
    );
  }
}
