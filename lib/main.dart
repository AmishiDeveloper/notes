import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes/screens/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,

          home:Scaffold(
              body: StreamBuilder(
              stream:FirebaseAuth.instance.authStateChanges(),
              builder:(ctx, snapshot)
              {
                if(snapshot.hasData)
                {
                  return Password();
                }
                else
                {
                  return LoginScreen();
                }
              }
          )
      )
  )
  );
}


