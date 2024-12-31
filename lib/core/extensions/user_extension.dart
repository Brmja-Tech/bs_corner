import 'package:pscorner/core/enums/user_role_enum.dart';

extension UserRoleX on UserRole {


  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'employee':
        return UserRole.employee;
      case 'supervisor':
        return UserRole.supervisor;
      default:
        throw ArgumentError('Invalid user role: $role');
    }
  }
  bool get isAdmin => this == UserRole.admin;
  bool get isEmployee => this == UserRole.employee;
  bool get isSupervisor => this == UserRole.supervisor;
}