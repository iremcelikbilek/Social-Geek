import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/components/already_have_an_account_acheck.dart';
import 'package:social_geek/components/rounded_button.dart';
import 'package:social_geek/components/rounded_input_field.dart';
import 'package:social_geek/components/rounded_password_field.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/utils/error_exception.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/auth/login_page.dart';
import 'package:social_geek/views/landing_page.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;


  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel.userModel != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LandingPage()));
      });
    }
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: (_userViewModel.viewState == ViewState.IDLE)
          ? buildBody()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildBody(){
    Size size = MediaQuery.of(context).size;
    final _userViewModel = Provider.of<UserViewModel>(context);
    return Container(
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/signup_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.25,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/signup.png",
                  height: size.height * 0.35,
                ),
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
                  text: "SIGNUP",
                  press: () => _formSubmit(context),
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                orDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    socialIcon(
                      iconSrc: "assets/images/google-plus.png",
                      press: () => _signInWithGoogle(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget socialIcon({String iconSrc, Function press}){
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: kPrimaryLightColor,
          ),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          iconSrc,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  Widget orDivider(){
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }

  void _formSubmit(BuildContext context) async{
    _formKey.currentState.save();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    try {
      UserModel _userModel =
      await userViewModel.createUserWithEmailPassword(_email, _password);
      if (_userModel != null)
        debugPrint(
            "Email şifre ile  oluşturulan user : ${_userModel.toString()}");
    } on FirebaseAuthException catch (e) {
      print("For submit create metodunda HATA :" + Errors.showError(e.code));
      userViewModel.emailErrorMessage = Errors.showError(e.code);
    }
  }

  void _signInWithGoogle(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userViewModel.signInWithGoogle();
    if(_user != null) debugPrint("Oturum Açan Google User: ${_user.userID}");
  }
}



