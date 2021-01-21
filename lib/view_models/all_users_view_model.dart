import 'package:flutter/material.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/repository/user_repository.dart';

enum AllUserViewState {Idle, Loaded, Busy}

class AllUsersViewModel with ChangeNotifier{
  UserRepository _repository = locator<UserRepository>();
  AllUserViewState _state = AllUserViewState.Idle;
  List<UserModel> _allUsers;
  UserModel _theLastUserToGet;
  static final _elementToBeGet = 10;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  List<UserModel> get allUsers => _allUsers;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUsersViewModel(){
    _allUsers = [];
    _theLastUserToGet = null;
    getUsersWithPagination(_theLastUserToGet, false);
  }

  Future<void> getUsersWithPagination(UserModel theLastUserToGet, bool isNewElement) async{

    if(_allUsers.length > 0){
      _theLastUserToGet = _allUsers.last;
    }

    if(isNewElement){

    }else{
      //_state değişkenini değil state kullanıyorum çünkü zaten set metodu benim _state değerime bu yeni değeri atıyor !!!
      state = AllUserViewState.Busy;
    }

    List<UserModel> newList = await  _repository.getUsersWithPagination(_theLastUserToGet, _elementToBeGet);

    if(newList.length < _elementToBeGet){
      _hasMore = false;
    }

    _allUsers.addAll(newList);
    state = AllUserViewState.Loaded;
  }

  Future<void> getMoreUsers() async{
    if(_hasMore) getUsersWithPagination(_theLastUserToGet, true);
    else print("Daha fazla eleman yok o yüzden eleman çağırılmayacak");
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async{
    _hasMore = true;
    _theLastUserToGet = null;
    getUsersWithPagination(_theLastUserToGet, false);
  }
}