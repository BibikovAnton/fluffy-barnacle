import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messanger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messanger/features/auth/presentation/pages/register_page.dart';

import 'email_input.dart';
import 'password_input.dart';
import 'name_input.dart';
import 'auth_button.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;

  const AuthForm({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isLogin) {
        context.read<AuthBloc>().add(
          LoginEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          RegisterEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            name: _nameController.text.trim(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.isLogin) NameInput(controller: _nameController),
          if (!widget.isLogin) const SizedBox(height: 16),
          EmailInput(controller: _emailController),
          const SizedBox(height: 16),
          PasswordInput(controller: _passwordController),
          const SizedBox(height: 24),
          AuthButton(
            onPressed: _submit,
            text: widget.isLogin ? 'Войти' : 'Зарегистрироваться',
          ),
          if (widget.isLogin)
            TextButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  ),
              child: const Text('Нет аккаунта? Зарегистрируйтесь'),
            ),
        ],
      ),
    );
  }
}
