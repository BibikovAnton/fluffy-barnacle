import 'package:messanger/features/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    String? email,
    String? name,
    String? photoUrl,
  }) : super(uid: uid, email: email, name: name, photoUrl: photoUrl);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name, 'photoUrl': photoUrl};
  }
}
