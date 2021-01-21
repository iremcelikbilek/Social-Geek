import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/components/already_have_an_account_acheck.dart';
import 'package:social_geek/components/rounded_button.dart';
import 'package:social_geek/components/rounded_input_field.dart';
import 'package:social_geek/components/rounded_password_field.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/utils/error_exception.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/auth/sign_up_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel.userModel != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }
    return Scaffold(
      body: (_userViewModel.viewState == ViewState.IDLE) ? buildBody(context) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    Size size = MediaQuery.of(context).size;
    return  Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/login.png",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundedInputField(
                        errorText: (_userViewModel.emailErrorMessage != null)
                            ? _userViewModel.emailErrorMessage
                            : null,
                        hintText: "Your Email",
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      RoundedPasswordField(
                        errorText: (_userViewModel.passwordErrorMessage != null)
                            ? _userViewModel.passwordErrorMessage
                            : null,
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                  text: "LOGIN",
                  press: () => _formSubmit(context),
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _formSubmit(BuildContext context) async {
    _formKey.currentState.save();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    try {
      UserModel _userModel =
      await userViewModel.signInWithEmailPassword(_email, _password);
      if (_userModel != null) debugPrint("Email şifre ile giriş yapan user : ${_userModel.toString()}");
    } on FirebaseAuthException catch (e) {
      debugPrint("For submit sign in metodunda HATA :" + e.code);
      userViewModel.emailErrorMessage = (e.code == "emaıl-already-ın-use") ? Errors.showError(e.code): null;
      userViewModel.passwordErrorMessage = (e.code == "wrong-password") ? Errors.showError(e.code): null;
    }
  }
}



