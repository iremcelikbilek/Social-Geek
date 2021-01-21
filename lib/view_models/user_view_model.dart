import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/models/chat.dart';
import 'package:social_geek/models/conversation.dart';
import 'package:social_geek/models/educator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/repository/user_repository.dart';
import 'package:social_geek/services/auth/auth_base.dart';

enum ViewState {IDLE, BUSY}

class UserViewModel with ChangeNotifier implements AuthBase{

  ViewState _viewState = ViewState.IDLE;
  UserRepository _userRepository = locator<UserRepository>();
  UserModel _userModel;
  String _emailErrorMessage, _passwordErrorMessage;
  String _aboutMe;


  get passwordErrorMessage => _passwordErrorMessage;

  set passwordErrorMessage(value) {
    _passwordErrorMessage = value;
    notifyListeners();
  }

  String get emailErrorMessage => _emailErrorMessage;

  set emailErrorMessage(String value) {
    _emailErrorMessage = value;
    notifyListeners();
  }

  UserViewModel(){
    currentUser();
  }

  UserModel get userModel => _userModel;

  set userModel(UserModel value) {
    _userModel = value;
    notifyListeners();
  }

  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  @override
  Future<UserModel> currentUser() async{
    try{
      viewState = ViewState.BUSY;
      _userModel = await _userRepository.currentUser();
      if(_userModel != null) return _userModel;
      else return null;
    }catch(e){
      debugPrint("ViewModel Current User Metodunda Hata : $e");
      return null;
    }finally{
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<bool> signOut() async{
    try{
      viewState = ViewState.BUSY;
      _userModel = null;
      return await _userRepository.signOut();
    }catch(e){
      debugPrint("ViewModel SignOut Metodunda Hata : $e");
      return false;
    }finally{
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async{
    try{
      viewState = ViewState.BUSY;
      _userModel = await _userRepository.signInWithGoogle();
      if(_userModel != null) return _userModel;
      else return null;
    }catch(e){
      debugPrint("ViewModel SignInWithGoogle Metodunda Hata : $e");
      return null;
    }finally{
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel> createUserWithEmailPassword(String email, String password) async{
    try{
      if(_emailPasswordCheck(email, password)){
        viewState = ViewState.BUSY;
        _userModel = await _userRepository.createUserWithEmailPassword(email, password);
        return _userModel;
      }else{
        return null;
      }
    }finally{
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) async{
    try{
      if(_emailPasswordCheck(email, password)){
        viewState = ViewState.BUSY;
        _userModel = await _userRepository.signInWithEmailPassword(email, password);
        return _userModel;
      }else{
        return null;
      }
    }finally{
      viewState = ViewState.IDLE;
    }
  }

  bool _emailPasswordCheck(String email, String password) {
    var result = true;

    if(!email.contains('@')){
      _emailErrorMessage = "Geçerli bir mail adresi giriniz";
      result = false;
    }else{
      _emailErrorMessage = null;
    }

    if(password.length < 6 ){
      _passwordErrorMessage = "Şifre en az 6 karakter olmalı";
      result = false;
    }else{
      _passwordErrorMessage = null;
    }

    return result;

  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var result = await _userRepository.updateUserName(userID, newUserName);
    if(result) userModel.userName = newUserName;
    return result;
  }

  Future<bool> updateAboutMe(String userID, String aboutMe) async {
    var result = await _userRepository.updateAboutMe(userID, aboutMe);
    if(result) userModel.aboutMe = aboutMe;
    return result;
  }

  Future<String> uploadFile(String userID, String fileType, File fileToUpload) async{
    var downloadLink = await _userRepository.uploadFile(userID, fileType, fileToUpload);
    userModel.profileURL = downloadLink;
    return downloadLink;
  }

  Future<List<UserModel>> getAllUsers() async{
    var allUsersList = await _userRepository.getAllUsers();
    return allUsersList;
  }

  Future<UserModel> getUser(String userID) async{
    var user = await _userRepository.getUser(userID);
    return user;
  }

  Stream<List<Chat>> getChat(String currentUserID, String typedUserID) {
    return _userRepository.getChat(currentUserID, typedUserID);
  }

  Future<bool> saveMessage(Chat messageToBeSaved, UserModel typedUser,currentUser) async{
    return await  _userRepository.saveMessage(messageToBeSaved,typedUser,currentUser);
  }

  Stream<List<Conversation>> getAllConversation(String userID) {
    return _userRepository.getAllConversations(userID);
  }

  Future<List<UserModel>> getUsersWithPagination(UserModel theLastUserToGet, int elementToBeGet) async{
    return await _userRepository.getUsersWithPagination(theLastUserToGet, elementToBeGet);
  }

  /// TAKİP İŞLEMLERİ

  Stream<int> getFollowsNumber(UserModel userMe){
    return _userRepository.getFollowsNumber(userMe);
  }

  Stream<int> getFollowersNumber(UserModel userMe){
    return _userRepository.getFollowersNumber(userMe);
  }

  Future<bool> checkFollow(UserModel userMe, UserModel otherUser) async{
    return await _userRepository.checkFollow(userMe, otherUser);
  }

  Future<bool> saveFollows(UserModel userMe, UserModel otherUser) async{
    return await _userRepository.saveFollows(userMe, otherUser);
  }

  Future<bool> saveUnfollow(UserModel userMe, UserModel otherUser) async{
    return await _userRepository.saveUnfollow(userMe, otherUser);
  }

  Stream<List<UserModel>> getFollows(UserModel userMe) {
    return _userRepository.getFollows(userMe);
  }

  Stream<List<UserModel>> getFollowers(UserModel userMe) {
    return _userRepository.getFollowers(userMe);
  }

  /// BLOG İŞLEMLERİ
  Future<bool> saveBlogPost(UserModel userModel, Blog blogPost) async{
    return await _userRepository.saveBlogPost(userModel, blogPost);
  }

  Stream<List<Blog>> getAllBlogPost(){
    return _userRepository.getAllBlogPost();
  }

  Stream<List<Blog>> getMyBlog(UserModel user){
    return _userRepository.getMyBlog(user);
  }

  Future<List<Blog>> getBlogWithPagination(Blog theLastBlogToGet, int elementToBeGet) async {
    return await getBlogWithPagination(theLastBlogToGet, elementToBeGet);
  }

  Future<bool> saveEducator(String subject, UserModel educator) async{
    return await _userRepository.saveEducator(subject, educator);
  }

  Stream<List<Educator>> getEducators(String subject) {
    return _userRepository.getEducators(subject);
  }
}