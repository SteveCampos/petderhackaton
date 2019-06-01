
import 'dart:async';
import 'package:adoptame/src/app.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _GoogleSignInSection(),
    );

  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  __GoogleSignInSectionState createState() => __GoogleSignInSectionState();
}

class __GoogleSignInSectionState extends State<_GoogleSignInSection> {
  bool _success;
  String _userID;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/login.png"),fit: BoxFit.cover),
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(padding: EdgeInsets.all(16),),
              GoogleSignInButton(
                onPressed: (){
                  _signInWithGoogle();
              }, darkMode: true,),
            ],
          ),
        );
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser = await auth.signInWithCredential(credential);
    assert(firebaseUser.displayName != null);
    assert(await firebaseUser.getIdToken()!= null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);

    print(firebaseUser.displayName);

    setState(() {
      if(firebaseUser != null){
        _success = true;
        _userID = firebaseUser.uid;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => App(user: firebaseUser,googleSignIn: googleSignIn,),

        ));
      }
    });
  }
}


