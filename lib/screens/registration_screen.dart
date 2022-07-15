import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/screens/chat_screen.dart';
import 'package:messageme_app/widgets/my_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  @override
  _RegistrationScreenState createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance; //this is for making a new user

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late String email;
  late String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        //this is for loading symbol when clicking the buttons
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(height: 50),

              //this is for email text field
              //.
              //.
              TextField(
                keyboardType: TextInputType.emailAddress,
                //this is for adding @ symbol to the mobile keyboard when first time opening it
                textAlign: TextAlign.center,

                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    //this is when i dont click it
                    borderSide: BorderSide(color: Colors.orange, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //this is when i  click it
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              //this is for passowrd text field
              //.
              //.

              TextField(
                obscureText: true,
                //this is for security to make the entered password to the dots

                textAlign: TextAlign.center,
                //this is forn making input text
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    //this is when i dont click it
                    borderSide: BorderSide(color: Colors.orange, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //this is when i  click it
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              //.
              //.
              //this is for register button
              MyButton(
                color: Colors.blue[800]!,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    //this is for calling the build method to refresh the whole method with the changes that wrote inside the set state method
                    showSpinner =
                        true; //this is the change that after refresh will work and enabled
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.screenRoute);
                    setState(() {
                      //in here means that when the register operation ended the loading symbol will stop
                      showSpinner = false;
                    });
                  } catch (e) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
