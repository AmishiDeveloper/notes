import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService
{
  signInWithGoogle(BuildContext context) async
  {
    final GoogleSignInAccount ? gUser =await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth =await gUser!.authentication;

    final credential =GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );
    final userCredential = await  FirebaseAuth.instance.signInWithCredential(credential);
    if(userCredential != null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>Password()), (route) => false);
    }
    return userCredential;
  }
}