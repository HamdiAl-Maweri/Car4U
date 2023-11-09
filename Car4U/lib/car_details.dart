import 'package:car4u/add_car_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'main.dart';


class CarDetailsPage extends StatefulWidget {

  final QueryDocumentSnapshot carData ;

  CarDetailsPage({required this.carData});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  @override

  List<String> images=[];
  String? currentUserName;
  bool isloading = true;

  // getData() async {
  //   DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  //   await FirebaseFirestore.instance.collection("car").doc(widget.carId).get();
  //   carData = documentSnapshot.data();
  //   images = carData?['images'].split(',');
  //   isloading=false;
  //   setState(() {
  //
  //   });
  // }

  Future<String?> getCurrentUserUsername() async {
    final userQuery = await FirebaseFirestore.instance
        .collection('users').doc(widget.carData?['user_id']).get();
    currentUserName =  userQuery["Name"];
    isloading=false;
      setState(() {

      });

  }


  @override
  void initState() {

    getCurrentUserUsername();

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:White,
      appBar: AppBar(
        backgroundColor: Dark,
        title: Text('Car Details'),
      ),
      body:isloading? Center(
        child: SpinKitFadingCircle (
          color: Orange,
          size: 75.0,
        ),
      ): SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 230,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.7,
                ),
                items: splitImages(widget.carData?['images']).map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(image);
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Dark,),
                  SizedBox(height: 15),
                  Text(
                    '${widget.carData?['name']}',
                    style: TextStyle(color:Dark,fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    '${widget.carData?['description']}',
                    style: TextStyle(color:Dark,fontSize: 16),
                  ),
                  Divider(color: Dark),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.attach_money,color: Dark),
                      Text(
                        '\$${widget.carData?['price']}',
                        style: TextStyle(color:Orange,fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 100),
                      Icon(Icons.location_on_outlined,color: Dark,),
                      Text(
                        '${widget.carData?['location']}',
                        style: TextStyle(color:Orange,fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Highlights',
                    style: TextStyle(color:Dark,fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(color: Dark),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today,color: Dark,),
                            SizedBox(height: 15),
                            Text(
                              'Year',
                              style: TextStyle(color: Dark, fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${widget.carData?['year']}',
                              style: TextStyle(color: Orange, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, color: Dark, height: 85), // Vertical divider
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.speed,color: Dark,),
                            SizedBox(height: 15),
                            Text(
                              'Kilometers',
                              style: TextStyle(color: Dark,fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${widget.carData?['kilometers']} Km',
                              style: TextStyle(color: Orange,fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, color: Dark, height: 85), // Vertical divider
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.local_gas_station,color: Dark,),
                            SizedBox(height: 15),
                            Text(
                              'Fuel Type',
                              style: TextStyle(color: Dark,fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${widget.carData?['fuel']}',
                              style: TextStyle(color: Orange,fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, color: Dark, height: 85), // Vertical divider
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.settings,color: Dark,),
                            SizedBox(height: 15),
                            Text(
                              'Gearbox',
                              style: TextStyle(color: Dark,fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${widget.carData?['gearbox']}',
                              style: TextStyle(color: Orange,fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(color: Dark),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.branding_watermark),
                          SizedBox(width: 15,),
                          Text(
                            "Brand",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 100,),
                          Text(
                            "${widget.carData?['brand']}",
                            style: TextStyle(
                              color: Orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Dark),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.model_training),
                          SizedBox(width: 15,),
                          Text(
                            "Model",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 100,),
                          Text(
                            "${widget.carData?['model']}",
                            style: TextStyle(
                              color: Orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Dark),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.color_lens),
                          SizedBox(width: 15,),
                          Text(
                            "Color",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 110),
                          Text(
                            "${widget.carData?['color']}",
                            style: TextStyle(
                              color: Orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Dark),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.format_shapes),
                          SizedBox(width: 15,),
                          Text(
                            "Body",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 110,),
                          Text(
                            "${widget.carData?['body']}",
                            style: TextStyle(
                              color: Orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Dark),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.ev_station),
                          SizedBox(width: 15,),
                          Text(
                            "Cylinders",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 80,),
                          Text(
                            "${widget.carData?['cylinder']}",
                            style: TextStyle(
                              color: Orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Dark),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(width: 15,),
                          Text(
                            "Condition",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 77,),
                          Text(
                            "${widget.carData?['condition']}",
                            style: TextStyle(
                              color: Orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Dark),

                      Row(
                        children: [
                          Text(
                            'Listed by: ',
                            style: TextStyle(color:Dark,fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${currentUserName == null ? "Admin" : currentUserName}',
                            style: TextStyle(color:Orange,fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
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
