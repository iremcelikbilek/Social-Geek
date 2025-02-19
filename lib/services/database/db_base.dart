import 'package:social_geek/models/chat.dart';
import 'package:social_geek/models/conversation.dart';
import 'package:social_geek/models/user_model.dart';

abstract class DbBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateAboutMe(String userID, String aboutMe);
  Future<bool> updateProfilePhoto(String userID, String downloadLink);
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> getUser(String userID);
  Stream<List<Conversation>> getAllConversation(String userID);
  Stream<List<Chat>> getChat(String currentUserID, String typedUserID);
  Future<bool> saveMessage(Chat messageToBeSaved, UserModel typedUser,currentUser);
  Future<DateTime> showTime(String userID);
  Future<List<UserModel>> getUsersWithPagination(UserModel theLastUserToGet, int elementToBeGet);

}