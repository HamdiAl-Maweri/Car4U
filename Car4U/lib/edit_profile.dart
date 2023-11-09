import 'package:flutter/material.dart';
import 'main.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserProfilePage extends StatefulWidget {

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();

}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userData;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  getData() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();
    userData = documentSnapshot.data();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      await _auth.currentUser!.updateEmail(_emailController.text.trim());
      await _auth.currentUser!.updatePassword(_emailController.text.trim());
      try {
        await FirebaseFirestore.instance.collection('users') .doc(_auth.currentUser!.uid).update({
          'Name': _nameController.text.trim(),
          'Email': _emailController.text.trim().toLowerCase(),
          'Phone': _phoneController.text.trim(),
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: White,
              title: Text('Success'),
              content: Text('Profile Updated Successfully'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK', style: TextStyle(color: Orange),),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                          (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: White,
              title: Text('Failed'),
              content: Text('Error: $e'),
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

  fillfields() async {
    await getData();
    if (userData != null) {
      _nameController.text = userData!['Name'];
      _emailController.text = userData!['Email'];
      _phoneController.text = userData!['Phone'];
      setState(() {
      });
    }
  }

  @override
  void initState() {
    fillfields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Dark,
        title: Text('Edit User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
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
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.toLowerCase().endsWith("gmail.com")) {
                    return 'Please enter a valid Gmail address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
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
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}