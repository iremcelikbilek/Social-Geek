import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'constant.dart';
import 'file:///C:/flutter_uygulamalar/social_geek/lib/views/app/profile/profile_page.dart';
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
          brightness: Brightness.dark,
          //primaryColor: ,
          accentColor: secondColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:AnimatedSplashScreen(
            splashIconSize: 200,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: backgroundColor,
            splashTransition: SplashTransition.fadeTransition,
            splash: Image.asset("assets/images/social_geek_logo.png"),
            nextScreen: LandingPage()),
      ),
    );
  }
}



