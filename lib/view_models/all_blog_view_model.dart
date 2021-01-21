import 'package:flutter/material.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/repository/user_repository.dart';

enum AllBlogViewState {Idle, Loaded, Busy}

class AllBlogViewModel with ChangeNotifier{
  UserRepository _repository = locator<UserRepository>();
  AllBlogViewState _state = AllBlogViewState.Idle;
  List<Blog> _allBlog;
  Blog _theLastBlogToGet;
  static final _elementToBeGet = 15;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  List<Blog> get allBlog => _allBlog;

  AllBlogViewState get state => _state;

  set state(AllBlogViewState value) {
    _state = value;
    notifyListeners();
  }

  AllBlogViewModel(){
    _allBlog = [];
    _theLastBlogToGet = null;
    getBlogWithPagination(_theLastBlogToGet, false);
  }

  Future<void> getBlogWithPagination(Blog theLastBlogToGet, bool isNewElement) async{

    if(_allBlog.length > 0){
      _theLastBlogToGet = _allBlog.last;
      print("En son getirilen userName : ${_theLastBlogToGet.article}");
    }

    if(isNewElement){

    }else{
      //_state değişkenini değil state kullanıyorum çünkü zaten set metodu benim _state değerime bu yeni değeri atıyor !!!
      state = AllBlogViewState.Busy;
    }

    List<Blog> newList = await  _repository.getBlogWithPagination(theLastBlogToGet, _elementToBeGet);
    newList.forEach((blog) => print("Getirilen article : ${blog.article}"));

    if(newList.length < _elementToBeGet){
      _hasMore = false;
    }

    _allBlog.addAll(newList);
    state = AllBlogViewState.Loaded;
  }

  Future<void> getMoreBlog() async{
    print("AllBlogViewModel'deki getMoreBlog tetiklendi");
    if(_hasMore) getBlogWithPagination(_theLastBlogToGet, true);
    else print("Daha fazla eleman yok o yüzden eleman çağırılmayacak");
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async{
    _hasMore = true;
    _theLastBlogToGet = null;
    getBlogWithPagination(_theLastBlogToGet, false);
  }
}