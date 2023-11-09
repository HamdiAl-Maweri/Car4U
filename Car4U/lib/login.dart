import 'package:car4u/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'sign_up.dart';
import 'main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var email, password;

  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading? Center(
        child: SpinKitFadingCircle (
          color: Orange,
          size: 75.0,
        ),
      ):Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 200.0),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: White,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    onSaved: (val){
                      email = val;
                    },
                    style: TextStyle(color: White),
                    cursorColor: White,
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      prefixIconColor: Orange,
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Orange),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!value.endsWith("@gmail.com")) {
                        return 'Please enter a valid Gmail address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    onSaved: (val){
                      password = val;
                    },

                    style: TextStyle(color: White),
                    cursorColor: White,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      prefixIconColor: Orange,
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Orange),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Orange),
                    ),
                    onPressed: () async {
                      isLoading = true;
                      setState(() {
                      });
                      var formdata = _formKey.currentState;
                      if (formdata!.validate()){
                        formdata.save();
                        UserCredential loggedInUser = await _login();
                        if (loggedInUser != null){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        }
                      }
                      isLoading = false;
                      setState(() {
                      });
                    },
                    child: Text('Login', style: TextStyle(color: White)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Don't Have an Account ?",
                      style: TextStyle(color: White),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _login() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {
      });
      String errorMessage = 'Wrong Email or Password';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
      // Add more cases to handle other Firebase authentication exceptions
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: White,
            title: Text('Login Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Orange),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      isLoading = false;
      setState(() {
      });
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: White,
            title: Text('Login Error'),
            content: Text('An unexpected error occurred.'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Orange),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}