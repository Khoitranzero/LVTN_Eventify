import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? token;
  final String id;
  final String email;
  final String? role;
  final String? password;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final bool? isActivated;

  const UserModel(
      {this.token,
      required this.id,
      required this.email,
      this.role,
      this.password,
      this.fullName,
      this.phone,
      this.avatarUrl,
      this.isActivated});

  factory UserModel.fromJson({required Map<String, dynamic> json}) {
    return UserModel(
        id: json['id'],
        email: json['email'],
        fullName: json['fullName'],
        phone: json['phone'],
        token: json['token'] ?? "Chưa có token");
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,email, fullName, phone, token];
}
