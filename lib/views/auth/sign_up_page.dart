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

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel.userModel != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }
    return Scaffold(
      body: (_userViewModel.viewState == ViewState.IDLE)
          ? Body()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class Body extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/images/google-plus.png",
                  press: () => _signInWithGoogle(context),
                ),
              ],
            )
          ],
        ),
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

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          child,
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class SocalIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocalIcon({
    Key key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
