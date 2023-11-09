import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login.dart';

final White = const Color(0xfffbe6bf);
final Orange = const Color(0xffd64612);
final Dark = const Color(0xff1e2b33);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAHdZKyMweVHrAJj3fJbYYj0pEViA8ccSk",
      appId: "1:193794055399:android:300ad3a07ebda671b49642",
      messagingSenderId: "193794055399",
      projectId: "car4u-b2678",
      storageBucket: "car4u-b2678.appspot.com",
    ),
  );
  runApp(CarSalesApp());
}

class CarSalesApp extends StatefulWidget {
  @override
  _CarSalesAppState createState() => _CarSalesAppState();
}

class _CarSalesAppState extends State<CarSalesApp> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    var currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      isLogin = currentUser != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Sales App',
      theme: ThemeData(
        primaryColor: Dark,
        scaffoldBackgroundColor: Dark,
        hintColor: Orange,
        primarySwatch: Colors.blue,
      ),
      home: isLogin ? HomePage() : Login(),
    );
  }
}