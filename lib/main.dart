import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/auth/login_page.dart';
import 'package:social_geek/views/auth/welcome_page.dart';
import 'package:social_geek/views/landing_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(108, 99, 255, 1.0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:LandingPage(),
      ),
    );
  }
}

/*AnimatedSplashScreen(
          splashIconSize: 200,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Color.fromRGBO(140,135,219, 1),
          splashTransition: SplashTransition.fadeTransition,
          splash: Image.asset("assets/images/social_geek_logo.png"),
          nextScreen: LoginScreen(),
        ),*/



/*Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(108, 99, 255, 1),
                Color.fromRGBO(255, 103, 160, 1),
                Color.fromRGBO(249, 168, 38, 1)
              ]
            ),
            image: DecorationImage(
              image: AssetImage("assets/images/social_geek_logo.png")
            )
          ),
        ),*/

