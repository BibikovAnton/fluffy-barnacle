import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messanger/features/auth/domain/entities/user_entities.dart';

import '../bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Показываем загрузку только если состояние - AuthLoading
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Обрабатываем ошибки
        if (state is AuthError) {
          return Center(child: Text(state.message));
        }

        // Получаем пользователя из разных состояний
        UserEntity? user;
        if (state is Authenticated) {
          user = state.user;
        } else if (state is ProfileUpdated) {
          user = state.user;
        } else if (state is Unauthenticated) {
          // Если пользователь не авторизован, перенаправляем на экран входа
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const Center(child: CircularProgressIndicator());
        }

        // Если пользователь не получен (например, состояние AuthInitial)
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профиль'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthBloc>().add(LogoutEvent()),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                  child:
                      user.photoUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name ?? 'Без имени',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  user.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (user.status?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.status!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showUpdateDialog(context, user!),
                  child: const Text('Редактировать профиль'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, UserEntity user) {
    final nameController = TextEditingController(text: user.name);
    final statusController = TextEditingController(text: user.status);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать профиль'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Имя'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Статус'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedUser = user.copyWith(
                  name: nameController.text.trim(),
                  status: statusController.text.trim(),
                );
                context.read<AuthBloc>().add(UpdateProfileEvent());
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}
