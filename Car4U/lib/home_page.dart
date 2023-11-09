import 'package:car4u/login.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'search_page.dart';
import 'sell_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
List<QueryDocumentSnapshot> carData1 = [];
List<QueryDocumentSnapshot> carData2 = [];

class _HomeState extends State<HomePage> {
  TextEditingController searchnameController = TextEditingController();

  bool isloading=true;
  getCars() async {
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance.collection("car").where("user_id", isEqualTo:"YRke9M8sLfZ6yLE6sLLSNgtdTP63").get();
    carData1.addAll(querySnapshot1.docs);
    carData1 = carData1.toSet().toList();
    print("________________________________________________________");
    print(carData1);
    QuerySnapshot querySnapshot2 =
    await FirebaseFirestore.instance.collection("car").where("user_id", isEqualTo: "SSRm2f00SugXalFnRDGnRyz4d7y1").get();
    carData2.addAll(querySnapshot2.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    carData1 = [];
    carData2 = [];
    getCars();
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 225, // Increase the height of the app bar
        backgroundColor: const Color(0xff1e2b33),
        elevation: 0,
        title: Column(
          children: [
            SizedBox(height: 15),
            Image.asset('assets/logo.png',
                color: Orange // Replace with your logo image path
                ),
            SizedBox(height: 7),
            Text(
              'The Greatest Selection of Verified Cars in Yemen',
              style: TextStyle(
                color: White,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: White,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchnameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Orange),
                  hintText: ('Search for New and Used Cars'),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onEditingComplete: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  SearchPage(searchBy:'name',value:searchnameController.text!=null?searchnameController.text:""),
                      ),
                    );
                },
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      body:isloading? Center(
        child: SpinKitFadingCircle (
          color: Orange,
          size: 75.0,
        ),
      ):  SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Search By Body Type',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Orange),
              ),
            ),
            Container(
              height: 115,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: carBodyTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  SearchPage(searchBy:'body',value:carBodyTypes[index].label),
                        ),
                      );
                    },
                    child: Card(
                      color: White,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            width: 100,
                            child: Image.asset(
                              carBodyTypes[index].imagePath,
                              fit: BoxFit.cover,
                              color: Orange, // Replace with your logo image path
                            ),
                          ),
                          Text(
                            carBodyTypes[index].label,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: Dark),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: White,
              thickness: 2,
              indent: 60,
              endIndent: 60,
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Search By Fuel Type',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Orange),
              ),
            ),
            Container(
              height: 115,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: carFuelTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(searchBy:'fuel',value:carFuelTypes[index].label),
                        ),
                      );
                    },
                    child: Card(
                      color: White,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            width: 100,
                            child: Image.asset(
                              carFuelTypes[index].imagePath,
                              fit: BoxFit.cover,
                              color: Orange,
                            ),
                          ),
                          Text(
                            carFuelTypes[index].label,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: Dark),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: White,
              thickness: 2,
              indent: 60,
              endIndent: 60,
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Latest Cars From Our Featured Dealers',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Orange),
              ),
            ),
            ListView(
              shrinkWrap: true,
             children: [
               Padding(
                 padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                 child: Column(
                   children: [
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text(
                         carData1[0]["user_id"],
                         style: TextStyle(
                           color: Orange,
                         ),
                       ),
                     ),
                     SizedBox(height: 5),
                     Container(
                       child: SingleChildScrollView(
                         scrollDirection: Axis.horizontal,
                         // Horizontal scroll
                         child: Row(
                           children: [
                             for (var car in carData1)
                               Container(
                                 width: (MediaQuery.of(context).size.width /
                                     100) *
                                     87,
                                 child: Card(
                                   color: White,
                                   child: Row(
                                     children: [
                                       // Car's image
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Image.network(
                                           car["images"],
                                           width: 120,
                                         ),
                                       ),
                                       Flexible(
                                         child: Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               car["name"],
                                               overflow:
                                               TextOverflow.ellipsis,
                                               style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 18,
                                               ),
                                             ),
                                             SizedBox(height: 5),
                                             // Car's price
                                             Text(
                                               car["price"],
                                               style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 color: Orange,
                                                 fontSize: 15,

                                               ),
                                             ),
                                             SizedBox(height: 5),
                                             // Car's details: Fuel Type, Year, Speed
                                             Row(
                                               children: [
                                                 Text(
                                                   car["fuel"],
                                                   style: TextStyle(
                                                     fontSize: 10,
                                                   ),
                                                 ),
                                                 Text(
                                                   ' | ',
                                                   style: TextStyle(
                                                     fontSize: 13,
                                                     fontWeight:
                                                     FontWeight.bold,
                                                     color: Orange,
                                                   ),
                                                 ),
                                                 Text(
                                                   car["year"],
                                                   style: TextStyle(
                                                       fontSize: 10
                                                   ),
                                                 ),
                                                 Text(
                                                   ' | ',
                                                   style: TextStyle(
                                                     fontWeight:
                                                     FontWeight.bold,
                                                     color: Orange,
                                                   ),
                                                 ),
                                                 Text(
                                                   car["kilometers"],
                                                   style: TextStyle(
                                                     fontSize: 10,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ],
                                         ),
                                       ),
                                       // Car's name
                                       SizedBox(
                                         width: 10,
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                 child: Column(
                   children: [
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text(
                         carData2[0]["user_id"],
                         style: TextStyle(
                           color: Orange,
                         ),
                       ),
                     ),
                     SizedBox(height: 5),
                     Container(
                       child: SingleChildScrollView(
                         scrollDirection: Axis.horizontal,
                         // Horizontal scroll
                         child: Row(
                           children: [
                             for (var car in carData2)
                               Container(
                                 width: (MediaQuery.of(context).size.width /
                                     100) *
                                     87,
                                 child: Card(
                                   color: White,
                                   child: Row(
                                     children: [
                                       // Car's image
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Image.network(
                                           car["images"],
                                           width: 120,
                                         ),
                                       ),
                                       Flexible(
                                         child: Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               car["name"],
                                               overflow:
                                               TextOverflow.ellipsis,
                                               style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 18,
                                               ),
                                             ),
                                             SizedBox(height: 5),
                                             // Car's price
                                             Text(
                                               car["price"],
                                               style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 color: Orange,
                                                 fontSize: 15,

                                               ),
                                             ),
                                             SizedBox(height: 5),
                                             // Car's details: Fuel Type, Year, Speed
                                             Row(
                                               children: [
                                                 Text(
                                                   car["fuel"],
                                                   style: TextStyle(
                                                     fontSize: 10,
                                                   ),
                                                 ),
                                                 Text(
                                                   ' | ',
                                                   style: TextStyle(
                                                     fontSize: 13,
                                                     fontWeight:
                                                     FontWeight.bold,
                                                     color: Orange,
                                                   ),
                                                 ),
                                                 Text(
                                                   car["year"],
                                                   style: TextStyle(
                                                       fontSize: 10
                                                   ),
                                                 ),
                                                 Text(
                                                   ' | ',
                                                   style: TextStyle(
                                                     fontWeight:
                                                     FontWeight.bold,
                                                     color: Orange,
                                                   ),
                                                 ),
                                                 Text(
                                                   car["kilometers"],
                                                   style: TextStyle(
                                                     fontSize: 10,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ],
                                         ),
                                       ),
                                       // Car's name
                                       SizedBox(
                                         width: 10,
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
               ),

             ],

            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index){
            case 0:
            break;
            case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
            break;
            case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SellPage()),
            );
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
        currentIndex: 0,
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


}

class CarBodyType {
  final String imagePath;
  final String label;

  CarBodyType({required this.imagePath, required this.label});
}

final List<CarBodyType> carBodyTypes = [
  CarBodyType(
    imagePath: 'assets/Sedan.jpg',
    label: 'Sedan',
  ),
  CarBodyType(
    imagePath: 'assets/SUVCrossover.jpg',
    label: 'SUV/Crossover',
  ),
  CarBodyType(
    imagePath: 'assets/Pick Up Truck.jpg',
    label: 'Pick Up Truck',
  ),
  CarBodyType(
    imagePath: 'assets/Hatchback.jpg',
    label: 'Hatchback',
  ),
  CarBodyType(
    imagePath: 'assets/Coupe.jpg',
    label: 'Coupe',
  ),
  CarBodyType(
    imagePath: 'assets/Bus.jpg',
    label: 'Bus',
  ),
  CarBodyType(
    imagePath: 'assets/Truck.jpg',
    label: 'Truck',
  ),
  CarBodyType(
    imagePath: 'assets/Van.jpg',
    label: 'Van',
  ),
  CarBodyType(
    imagePath: 'assets/Bike.jpg',
    label: 'Bike',
  ),
  // Add more car body types with their respective image paths and labels
];

class CarFuelType {
  final String imagePath;
  final String label;

  CarFuelType({required this.imagePath, required this.label});
}

final List<CarFuelType> carFuelTypes = [
  CarFuelType(
    imagePath: 'assets/Gasoline.jpg',
    label: 'Gasoline',
  ),
  CarFuelType(
    imagePath: 'assets/Diesel.jpg',
    label: 'Diesel',
  ),
  CarFuelType(
    imagePath: 'assets/Hybrid.jpg',
    label: 'Hybrid',
  ),
  CarFuelType(
    imagePath: 'assets/Electric.jpg',
    label: 'Electric',
  )
];

class Dealer {
  String name;
  List<Car> car;

  Dealer({required this.name, required this.car});
}

class Car {
  String name;
  String price;
  String fuelType;
  String year;
  String speed;
  String image;

  Car({
    required this.name,
    required this.price,
    required this.fuelType,
    required this.year,
    required this.speed,
    required this.image,
  });
}

List<Dealer> dealers = [
  Dealer(name: "Al Fadhel", car: [
    Car(
      name: "Ferrari",
      price: "10 Million YER",
      fuelType: "ne",
      year: "2022",
      speed: "200 km/h",
      image: "assets/car1.jpg",
    ),
    Car(
      name: "Ferrari",
      price: "10 Million YER",
      fuelType: "Gasoline",
      year: "2022",
      speed: "200 km/h",
      image: "assets/car1.jpg",
    ),
    Car(
      name: "Ferrari",
      price: "10 Million YER",
      fuelType: "Gasoline",
      year: "2022",
      speed: "200 km/h",
      image: "assets/car1.jpg",
    ),
  ]),
  Dealer(name: "AL-SHEHAB", car: [
    Car(
      name: "Bugatti",
      price: "15000\$",
      fuelType: "Diesel",
      year: "2021",
      speed: "180 km/h",
      image: "assets/car2.jpg",
    ),
    Car(
      name: "Bugatti",
      price: "15000\$",
      fuelType: "Diesel",
      year: "2021",
      speed: "180 km/h",
      image: "assets/car2.jpg",
    ),
  ]),
  // Add more dealers and cars as needed
];
