import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/services/auth/auth_base.dart';

class FakeAuthServices extends AuthBase{

  String userId = "132323232424";
  String userEmail = "fakeuser@fake.com";

  @override
  Future<UserModel> currentUser() async{
    return UserModel(userID: userId, eMail: userEmail);
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGoogle() {
    return Future.delayed(Duration(seconds: 2), () => UserModel(userID: "google_user_id_1324243", eMail: userEmail));
  }

  @override
  Future<UserModel> createUserWithEmailPassword(String email, String password) {
    return Future.delayed(Duration(seconds: 2), () => UserModel(userID: "create_user_id_1324243", eMail: userEmail));
  }

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) {
    return Future.delayed(Duration(seconds: 2), () => UserModel(userID: "signedIn_user_id_1324243", eMail: userEmail));
  }

}