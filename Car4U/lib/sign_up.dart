import 'package:car4u/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'login.dart';
import 'main.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var name, email, phone, password;

  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading? Center(
        child: SpinKitFadingCircle (
          color: Orange,
          size: 75.0,
        ),
      ):Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 150.0),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: White,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onSaved: (val){
                  name = val;
                },
                style: TextStyle(color: White),
                controller: _nameController,
                cursorColor: White,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  prefixIconColor: Orange,
                  labelText: 'Name',
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
                    return 'Please enter your name';
                  }
                  if (value.length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onSaved: (val){
                  phone = val;
                },
                style: TextStyle(color: White),
                cursorColor: White,
                controller: _phoneController,
                keyboardType: TextInputType.number, // Set the keyboard type to number
                inputFormatters: [
                  LengthLimitingTextInputFormatter(9), // Limit the input to 9 characters
                ],
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  prefixIconColor: Orange,
                  labelText: 'Phone',
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
                    return 'Please enter your phone number';
                  }
                  if (value.length != 9 || int.tryParse(value) == null) {
                    return 'Please enter a valid 9-digit phone number';
                  }
                  if (!value.startsWith("7")) {
                    return 'Please enter a valid Yemeni phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onSaved: (val){
                  email = val;
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.toLowerCase().endsWith("gmail.com")) {
                    return 'Please enter a valid Gmail address';
                  }
                  return null;
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
                    UserCredential response = await _signup();
                    if (response != null){
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
                child: Text('Sign Up', style: TextStyle(color: White)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  "Already Have an Account?",
                  style: TextStyle(color: White),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signup() async {


    try {

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      CollectionReference userref = FirebaseFirestore.instance.collection("users");
      await userref.doc(FirebaseAuth.instance.currentUser!.uid).set(
          {
            "Name": _nameController.text.trim(),
            "Email": _emailController.text.trim().toLowerCase(),
            "Phone" : _phoneController.text.trim(),
          });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {
      });
      switch (e.code){
        case "weak-password":
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: White,
                title: Text('Weak Password'),
                content: Text('Please try a stronger one'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK', style: TextStyle(color: Orange),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          break;
        case "email-already-in-use":

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: White,
                title: Text('Email Already in Use'),
                content: Text('You may already have an account, please try logging in.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK', style: TextStyle(color: Orange),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          break;
        default:
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: White,
                title: Text('Sign Up Failed'),
                content: Text('An error occurred during sign up'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK', style: TextStyle(color: Orange),),
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

}