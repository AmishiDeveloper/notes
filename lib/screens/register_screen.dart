import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes/authService.dart';
import 'package:flutter_notes/screens/LoginScreen.dart';
import 'package:flutter_notes/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_notes/screens/LoginScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final auth= AuthService();
  String ?email;
  String ?pass;

  @override
  Widget build(BuildContext context) {
    //ScaffoldMessenger.of(context).clearSnackBars();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          labelText: 'Email', hintText: 'xyz@gmail.com'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid email id';
                        }
                        return null;
                      },
                      onSaved: (value){
                        email=value;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _pwdController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'password', hintText: 'Xyz@1234'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid  password having 10 characters';
                        }
                        if(value.length<6)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password is weak'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                        return null;
                      },
                      onSaved: (value){
                        pass=value;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //_onSaved();
                        //clear();
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                              email: _emailController.text, password: _pwdController.text);
                          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>LoginScreen()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Password is too weak'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('email already exists'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }

                      },
                      child: Text('Register'),
                    ),

                    // ElevatedButton.icon(
                    //   style: ElevatedButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.blue[100]),
                    //   onPressed: (){
                    //     _googleSignIn.signIn().then((value){
                    //       String userName=value!.displayName!;
                    //       String profilePicture=value!.photoUrl!;
                    //     });
                    //   },
                    //   icon: Image.asset('assets/images/img.png',width: 20,height: 20,),
                    //   label: Text("Google Sign_in"),
                    // ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.blue[100]),
                      onPressed: (){
                        // _googleSignIn.signIn().then((value){
                        //   String userName=value!.displayName!;
                        //   String profilePicture=value!.photoUrl!;
                        //var auth=AuthService;
                        auth.signInWithGoogle(context);

                      },
                      icon: Image.asset('assets/images/img.png',width: 20,height: 20,),
                      label: Text("Google Sign_in"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
