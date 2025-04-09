class UserModel {
  final String id;
  final String name;
  final String profileImage;
  final String bio;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.bio,
    required this.email,
  });

  // Преобразуем из Firestore документа в объект UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      bio: json['bio'],
      email: json['email'],
    );
  }

  // Преобразуем обратно в Map для сохранения в Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'bio': bio,
      'email': email,
    };
  }
}
