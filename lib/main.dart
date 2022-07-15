import 'package:flutter/material.dart';
import 'package:messageme_app/screens/chat_screen.dart';
import 'package:messageme_app/screens/registration_screen.dart';
import 'package:messageme_app/screens/signin_screen.dart';
import '../screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  //this CODE is necessary for starting using firebase in m code
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: ' Message Me',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: WelcomeScreen(),//we cant use this home and initial route in the same time because they both do same work
        initialRoute: _auth.currentUser !=null ? ChatScreen.screenRoute:WelcomeScreen.screenRoute,//this code is for when the current user is signed in then start at the chst screen but if current user is null it means that he didnt sign in then go to welcome screen
        //this is for selecting the main screen that opens in the first time when we open the app
        routes: {
          WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
          SignInScreen.screenRoute: (context) => SignInScreen(),
          RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
          ChatScreen.screenRoute: (context) => ChatScreen(),
        });
  }
}
