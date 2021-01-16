import 'dart:io';

import 'package:social_geek/locator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/services/auth/auth_base.dart';
import 'package:social_geek/services/auth/fake_auth_service.dart';
import 'package:social_geek/services/auth/firebase_auth_service.dart';
import 'package:social_geek/services/database/firestore_db_service.dart';

enum AppMode {DEBUG, RELEASE}

class UserRepository implements AuthBase{

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthServices _fakeAuthServices = locator<FakeAuthServices>();
  FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();


  AppMode appMode = AppMode.RELEASE;

  List<UserModel> allUsers = [];
  Map<String, String> userTokenList = Map<String, String>();

  @override
  Future<UserModel> currentUser() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthServices.currentUser();
    }else{
      UserModel _user = await _firebaseAuthService.currentUser();
      if(_user != null) return await _firestoreDbService.readUser(_user.userID);
      else return null;
    }
  }

  @override
  Future<bool> signOut() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthServices.signOut();
    }else{
      return await _firebaseAuthService.signOut();
    }
  }

  //Firestore'dan gelen saveUser metodu eklendi.
  @override
  Future<UserModel> signInWithGoogle() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthServices.signInWithGoogle();
    }else{
      UserModel _user = await _firebaseAuthService.signInWithGoogle();
      if(_user != null){
        bool result = await _firestoreDbService.saveUser(_user);
        if(result){
          //auth ile gelen user'ı değil firestore'a kaydettiğim user'ı return etmek istiyorum
          return await _firestoreDbService.readUser(_user.userID);
        }else{
          await _firebaseAuthService.signOut();
          return null;
        }
      }
      else return null;
    }
  }

  //Firestore'dan gelen saveUser metodu eklendi.
  @override
  Future<UserModel> createUserWithEmailPassword(String email, String password) async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthServices.createUserWithEmailPassword(email, password);
    }else{
      UserModel _user = await _firebaseAuthService.createUserWithEmailPassword(email, password);
      bool result = await _firestoreDbService.saveUser(_user);
      if(result){
        //auth ile gelen user'ı değil firestore'a kaydettiğim user'ı return etmek istiyorum
        return await _firestoreDbService.readUser(_user.userID);
      }else return null;
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthServices.signInWithEmailPassword(email, password);
    }else{
      //auth ile gelen user'ı değil firestore'a kaydettiğim user'ı return etmek istiyorum
      UserModel _registeredUser = await _firebaseAuthService.signInWithEmailPassword(email, password);
      return await _firestoreDbService.readUser(_registeredUser.userID);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async{
    if(appMode == AppMode.DEBUG){
      //return await _fakeAuthServices.signInWithEmailPassword(email, password);
      return false;
    }else {
      bool _result = await _firestoreDbService.updateUserName(
          userID, newUserName);
      return _result;
    }
  }

  /*Future<String> uploadFile(String userID, String fileType, File fileToUpload) async{
    if(appMode == AppMode.DEBUG){
      return null;
    }else {
      String downloadLink = await _firebaseStorageService.uploadFile(userID, fileType, fileToUpload);
      await _firestoreDbService.updateProfilePhoto(userID,downloadLink);
      return downloadLink;
    }

  }*/

  Future<List<UserModel>> getAllUsers() async{
    if(appMode == AppMode.DEBUG){
      return [];
    }else {
      allUsers = await _firestoreDbService.getAllUsers();
      return allUsers;
    }
  }

  Future<UserModel> getUser(String userID) async{
    if(appMode == AppMode.DEBUG){
      return null;
    }else {
      var user = await _firestoreDbService.getUser(userID);
      return user;
    }
  }

}