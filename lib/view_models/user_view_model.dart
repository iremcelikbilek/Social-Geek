import 'dart:io';


import 'package:flutter/material.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/repository/user_repository.dart';
import 'package:social_geek/services/auth/auth_base.dart';

enum ViewState {IDLE, BUSY}

class UserViewModel with ChangeNotifier implements AuthBase{

  ViewState _viewState = ViewState.IDLE;
  UserRepository _userRepository = locator<UserRepository>();
  UserModel _userModel;
  String _emailErrorMessage, _passwordErrorMessage;

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
    if(result) _userModel.userName = newUserName;
    return result;
  }

}