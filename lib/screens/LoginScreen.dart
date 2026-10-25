import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes/authService.dart';
import 'package:flutter_notes/screens/home_screen.dart';
import 'package:flutter_notes/screens/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //var _isLoading=false;
  final _formKey = GlobalKey<FormState>();
   final auth= new AuthService();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String ?email;
  String ?pass;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid email id';
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
                              .signInWithEmailAndPassword(
                              email: _emailController.text, password: _pwdController.text);
                          Navigator.push(context,MaterialPageRoute(builder: (ctx)=>Password()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                      },
                      child: Text('Login'),
                    ),

                   // InkWell(
                   //   child: Image.asset('assets/images/imp.png'),
                   //   onTap: ()
                   //   {
                   //
                   //   },
                   // ),
                   //ElevatedButton(onPressed: (){}, child: Text("Sign in with google"))

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.blue[100]),
                      onPressed: (){
                        // _googleSignIn.signIn().then((value){
                        //   String userName=value!.displayName!;
                        //   String profilePicture=value!.photoUrl!;
                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx)=>Password()),(route)=>false);
                        //Navigator.push(context,MaterialPageRoute(builder: (ctx)=>Password()));
                        // setState(() {
                        //   _isLoading=true;
                        //   if(_isLoading){
                        //   return Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        //
                        // });
                        auth.signInWithGoogle(context);
                        },
                      icon: Image.asset('assets/images/img.png',width: 20,height: 20,),
                      label: Text("Google Sign_in"),
                    ),

                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>RegisterScreen()));
                      },
                      child: Text('Register Yourself'),
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
