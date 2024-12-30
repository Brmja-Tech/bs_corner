import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String password;
  final String role;

  const UserModel(
      {required this.id, required this.username, required this.role,required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['name'],
      password: json['password'],
      role: json['role'],
    );
  }

  @override
  List<Object?> get props => [id, username, role];
}
