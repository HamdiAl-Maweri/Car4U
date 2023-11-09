import 'package:car4u/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'add_car_page.dart';
import 'car_details.dart';
import 'edit_car_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'login.dart';
import 'edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

List<String> images = [];

class SellPage extends StatefulWidget{
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {

  List<QueryDocumentSnapshot> carData = [];
  String? currentUserName;
  bool isloading=true;

  getCars() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid.toString();
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("car").where("user_id", isEqualTo: currentUser).get();
    carData.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  Future<String?> getCurrentUserUsername() async {
    print("==========================1");

    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: currentUserEmail)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userData = userQuery.docs.first.data();
      final username = userData['Name'].toString();
      currentUserName = username;
      print("getCurrentUserUsername");
      print(currentUserName);
      print("==========================");

    } else {
      return null; // User not found
    }
  }

  @override
  void initState() {
    getCurrentUserUsername();
    getCars();
    print("initState");
    print(currentUserName);
    print("==========================");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1e2b33),
        toolbarHeight: 100,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Welcome, ${currentUserName == null ?"User :)": "${currentUserName} :)"}', style: TextStyle(color: Orange)),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome back to YemenCars',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: White),
                ),
              ),
              Divider(
                color: White,
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(White)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditUserProfilePage()),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Dark,
                  ),
                  label: Text('Edit Profile', style: TextStyle(color: Dark)),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(White)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                          (route) => false,
                    );
                    },
                  icon: Icon(
                    Icons.logout,
                    color: Dark,
                  ),
                  label: Text('Logout', style: TextStyle(color: Dark)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isloading? Center(
        child: SpinKitFadingCircle (
          color: Orange,
          size: 75.0,
        ),
      ): SingleChildScrollView(
        child: Column(
          children: carData.length > 0
              ? [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: carData.length,
              itemBuilder: (context, index) {
                // final car = carData[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailsPage(carData : carData[index]),
                      ),
                    );
                  },
                  child: Card(
                    color: White,
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, top: 8, right: 8),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              viewportFraction: 1.0,
                            ),
                            items:  splitImages(carData[index]['images']).map((image) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Image.network(image);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 5, left: 10),
                            child: Text(carData[index]['name'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Dark)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 5, left: 10),
                            child: Text('\$${carData[index]['price']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Orange)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(carData[index]['location'],
                                    style: TextStyle(fontSize: 12)),
                              ]),
                              Text(
                                "|",
                                style: TextStyle(
                                    color: Orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(carData[index]['model'].toString(),
                                    style: TextStyle(fontSize: 12)),
                              ]),
                              Text(
                                "|",
                                style: TextStyle(
                                    color: Orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(children: [
                                Icon(
                                  Icons.speed_rounded,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text('${carData[index]['kilometers']} km',
                                    style: TextStyle(fontSize: 12)),
                              ]),
                              Text(
                                "|",
                                style: TextStyle(
                                    color: Orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(children: [
                                Image.asset(
                                  'assets/gearbox.png',
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(carData[index]['gearbox'],
                                    style: TextStyle(fontSize: 12)),
                              ]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStatePropertyAll(Dark)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditCarPage(carData:carData[index])),
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: White,
                                ),
                                label: Text('Edit',
                                    style: TextStyle(color: White)),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStatePropertyAll(Dark)),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: White,
                                        title: Text('Confirm Delete'),
                                        content: Text('Are you sure you want to delete this Car?'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel',style: TextStyle(color: Dark),),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Delete',style: TextStyle(color: Orange),),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance.collection("car").doc(carData[index].id).delete();
                                              Navigator.of(context).pop();
                                              setState(() {
                                                carData.removeAt(index);
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: White,
                                ),
                                label: Text('Delete',
                                    style: TextStyle(color: White)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ]
              : [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            Image.asset('assets/no_car.png'),
            Center(
                child: Text(
                  "You Haven't Added Cars to Your Sell List",
                  style: TextStyle(color: White),
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(Orange)),
                      onPressed: () {},
                      child: Text(
                        "Sell Your First Car",
                        style: TextStyle(color: White),
                      ))),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Orange,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCarPage()),
          );
        },
      ),      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index){
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
              break;
            case 2:

              break;
            default:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              break;
          }

        },
        selectedItemColor: Orange,
        unselectedItemColor: White,
        currentIndex: 2,
        backgroundColor: Color(0xff1e2b33),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.directions_car_filled_rounded,
            ),
            label: 'Sell',
          ),
        ],
      ),
    );
  }
  List<String> splitImages(String images){
    List<String> i = images.split(',');
    if (i[i.length-1]==""){
      i.removeAt(i.length-1);
    }
    return i ;
  }
}
