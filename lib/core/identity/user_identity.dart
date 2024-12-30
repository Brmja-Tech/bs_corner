import 'package:pscorner/features/auth/data/models/user_model.dart';

abstract interface class UserData {
  static UserModel? model;
  static void setUser(UserModel user) {
    model = user;
  }
}