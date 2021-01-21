import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/home_page.dart';
import 'package:social_geek/views/auth/login_page.dart';
import 'package:social_geek/views/auth/welcome_page.dart';


class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _userViewModel = Provider.of<UserViewModel>(context);

    if(_userViewModel.viewState == ViewState.IDLE){
      if(_userViewModel.userModel == null){
        return LoginScreen();
      }else{
        return HomePage(id: _userViewModel.userModel.userID,);
      }
    }else{
      return Scaffold(
        appBar: AppBar(title: Text("Hoşgeldiniz"),),
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}