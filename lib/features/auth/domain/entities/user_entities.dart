import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserEntity({required this.uid, this.email, this.displayName, this.photoURL});

  bool get isAnonymous => uid.isEmpty;

  @override
  // TODO: implement props
  List<Object?> get props => [uid, email, displayName, photoURL];
}
