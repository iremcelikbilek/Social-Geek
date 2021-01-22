import 'package:flutter/material.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/repository/user_repository.dart';

class SearchViewModel with ChangeNotifier{
  UserRepository _repository = locator<UserRepository>();

  Future<List<UserModel>> getSearch(String query) async{
    List<UserModel> users = await _repository.getAllUsers();

    List<UserModel> filteredContacts = users.where((user) => user.userName.startsWith(query ?? "")).toList();

    return filteredContacts;
  }

}