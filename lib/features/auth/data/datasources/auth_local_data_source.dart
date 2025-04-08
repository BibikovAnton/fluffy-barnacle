import 'dart:convert';

import 'package:messanger/features/auth/domain/entities/user_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserEntity user);
  Future<UserEntity?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserEntity user) async {
    final userJson = {
      'uid': user.uid,
      'email': user.email,
      'name': user.name,
      'photoUrl': user.photoUrl,
    };
    await _prefs.setString('cached_user', jsonEncode(userJson));
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final jsonString = _prefs.getString('cached_user');
    if (jsonString != null) {
      final userJson = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserEntity(
        uid: userJson['uid'],
        email: userJson['email'],
        name: userJson['name'],
        photoUrl: userJson['photoUrl'],
      );
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove('cached_user');
  }
}
