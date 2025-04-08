import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

import '../widgets/auth_form.dart';
import '../widgets/error_snackbar.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ErrorSnackBar.show(context, state.message);
          }
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: AuthForm(isLogin: false),
        ),
      ),
    );
  }
}
