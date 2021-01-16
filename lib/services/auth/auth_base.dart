import 'package:social_geek/models/user_model.dart';

abstract class AuthBase{
  Future<UserModel> currentUser();
  Future<bool> signOut();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> createUserWithEmailPassword(String email, String password);
}