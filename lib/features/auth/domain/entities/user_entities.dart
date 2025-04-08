import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? status;
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    this.email,
    this.name,
    this.photoUrl,
    this.status,
    this.createdAt,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
    String? status,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [uid, email, name, photoUrl, status, createdAt];
}
