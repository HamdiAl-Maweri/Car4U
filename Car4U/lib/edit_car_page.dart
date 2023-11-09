import 'package:car4u/car_details.dart';
import 'package:car4u/search_page.dart';
import 'package:car4u/sell_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:car4u/add_car_page.dart';

import 'main.dart';

class EditCarPage extends StatefulWidget {
  final QueryDocumentSnapshot carData;

  EditCarPage({required this.carData});
  @override
  _EditCarPageState createState() => _EditCarPageState();
}


class _EditCarPageState extends State<EditCarPage> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  List<String> images = [];



  List<String> selectedPictures = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController kilometersController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController gearboxController = TextEditingController();
  TextEditingController cylinderController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController imagesController = TextEditingController();
  // Color selectedColor = Colors.transparent;

  CollectionReference car = FirebaseFirestore.instance.collection('car');
  List<String> brands = [
    'Toyota',
    'Ford',
    'Chevrolet',
    'Honda',
    'Volkswagen',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Nissan',
    'Hyundai',
    'Kia',
    'Subaru',
    'Tesla',
    'Volvo',
    'Porsche',
    'Jaguar',
    'Land Rover',
    'Mazda',
    'Mitsubishi',
    'Fiat',
  ];
  Future<void> editCar() async {
    print("_______________________________________________________________________________1");
    if (formState.currentState!.validate()) {
      print("_______________________________________________________________________________2 ${widget.carData.id}");

      try {
         await car.doc(widget.carData.id).update({
          'name': nameController.text,
          'model': modelController.text,
          'brand': brandController.text,
          'year': yearController.text,
          'price': priceController.text,
          'kilometers': kilometersController.text,
          'body': bodyController.text,
          'gearbox': gearboxController.text,
          'cylinder': cylinderController.text,
          'fuel': fuelController.text,
          'condition': conditionController.text,
          'location': locationController.text,
          'color': colorController.text,
          'images': imagesController.text,
          'description': descriptionController.text,
        });
         print("_______________________________________________________________________________3");

      } catch (e) {
        print("Error $e");
      }
    }
  }

  fillfields() {
    print(brandController.text==""? null: brandController.text);
    // await getData();
    print(widget.carData);
    if (widget.carData != null) {
      nameController.text = widget.carData!['name'];
      modelController.text = widget.carData!['model'];
      brandController.text = widget.carData!['brand'];
      priceController.text = widget.carData!['price'];
      kilometersController.text = widget.carData!['kilometers'];
      bodyController.text = widget.carData!['body'];
      gearboxController.text = widget.carData!['gearbox'];
      cylinderController.text = widget.carData!['cylinder'];
      descriptionController.text = widget.carData!['description'];
      conditionController.text = widget.carData!['condition'];
      locationController.text = widget.carData!['location'];
      colorController.text = widget.carData!['color'];
      fuelController.text = widget.carData!['fuel'];
      yearController.text = widget.carData!['year'];
      imagesController.text = widget.carData!['images'];
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fillfields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Dark,
      appBar: AppBar(
        backgroundColor: White,
        title: Text(
          'Edit Car',
          style: TextStyle(color: Orange),
        ),
      ),
      body: Form(
        key: formState,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                SizedBox(height: 16),
                Container(
                  child: TextFormField(
                    controller: nameController,
                    style: TextStyle(color: White),
                    cursorColor: Orange,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      prefixIconColor: Orange,
                      labelText: 'Car Name',
                      labelStyle: TextStyle(color: Orange),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                  ),
                ),

                // Price field
                SizedBox(height: 16),
                Container(
                  child: TextFormField(
                    controller: priceController,
                    style: TextStyle(color: White),
                    cursorColor: Orange,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money, color: Orange),
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Orange),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                  ),
                ),

                // Model field
                SizedBox(height: 16),
                Container(
                  child: TextFormField(
                    controller: modelController,
                    style: TextStyle(color: White),
                    cursorColor: Orange,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category_sharp, color: Orange),
                      labelText: 'Model',
                      labelStyle: TextStyle(color: Orange),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                  ),
                ),

                // Brand field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: brandController.text==""? null : brandController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.branding_watermark, color: Orange),
                      labelText: 'Brand',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: brands.map((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        brandController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),

                // Kilometers field
                SizedBox(height: 16),
                Container(
                  child: TextFormField(
                    controller: kilometersController,
                    style: TextStyle(color: White),
                    cursorColor: Orange,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.timeline, color: Orange),
                      labelText: 'Kilometers',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                  ),
                ),

                // Location field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: locationController.text==""? null : locationController.text,
                    decoration: InputDecoration(
                      prefixIcon:Icon(Icons.location_on_rounded, color: Orange),
                      labelText: 'Location',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: locationOptions.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        locationController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),
                // Fuel field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: fuelController.text==""? null : fuelController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.local_gas_station, color: Orange),
                      labelText: 'Fuel',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: fuelOptions.map((String fuel) {
                      return DropdownMenuItem<String>(
                        value: fuel,
                        child: Text(fuel,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        fuelController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),

                // year field
                SizedBox(height: 16),
                Container(
                  child: TextFormField(
                    controller: yearController,
                    style: TextStyle(color: White),
                    cursorColor: Orange,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.edit_calendar, color: Orange),
                      labelText: 'Year',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                  ),
                ),

                // Color field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: colorController.text==""? null : colorController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.color_lens, color: Orange),
                      labelText: 'Color',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: colorOptions.map((String color) {
                      return DropdownMenuItem<String>(
                        value: color,
                        child: Text(color,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        colorController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),

                // Body field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: bodyController.text==""? null : bodyController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.directions_car, color: Orange),
                      labelText: 'Body',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: typeOptions.map((String body) {
                      return DropdownMenuItem<String>(
                        value: body,
                        child: Text(body,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        bodyController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),

                // Gearbox field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: gearboxController.text==""? null : gearboxController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.compare_arrows, color: Orange),
                      labelText: 'Gearbox',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: gearOptions.map((String gearbox) {
                      return DropdownMenuItem<String>(
                        value: gearbox,
                        child: Text(gearbox,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        gearboxController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),

                // Cylinder field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: cylinderController.text==""? null : cylinderController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.crop_rotate, color: Orange),
                      labelText: 'Cylinders',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: cylindersOptions.map((String cylinder) {
                      return DropdownMenuItem<String>(
                        value: cylinder,
                        child: Text(cylinder,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cylinderController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),


                // Condition field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: conditionController.text==""? null : conditionController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.check_circle, color: Orange),
                      labelText: 'Condition',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                    items: carConditionOptions.map((String condition) {
                      return DropdownMenuItem<String>(
                        value: condition,
                        child: Text(condition,
                          style: TextStyle(color: White),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        conditionController.text = value as String;
                      });
                    },
                    dropdownColor: Dark,
                  ),
                ),

                // Description field
                SizedBox(height: 16),
                Container(
                  child: TextFormField(
                    controller: descriptionController,
                    style: TextStyle(color: White),
                    cursorColor: Orange,
                    decoration: InputDecoration(
                      prefixIcon:Icon(Icons.description_outlined, color: Orange),
                      labelText: 'Description',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: White),
                      ),
                      labelStyle: TextStyle(color: Orange),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Orange),
                      ),
                    ),
                  ),
                ),


                // Images field
                SizedBox(height: 16),
                // Row(
                //   children: [
                //     SizedBox(width: 13), // Add some spacing between the icon and text
                //     Icon(Icons.image_outlined, color: Orange), // Add the icon
                //     SizedBox(width: 10), // Add some spacing between the icon and text
                //     Text('Images',
                //       style: TextStyle(color: Orange ,fontSize: 16),
                //     ), // Add the text
                //   ],
                // ),
                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: White, // Set the border color
                //       width: 1.0, // Set the border width
                //     ),
                //     borderRadius:
                //     BorderRadius.circular(8), // Set the border radius
                //   ),
                //   child:Wrap(
                //     spacing: 5,
                //     runSpacing: 5,
                //     children: selectedPictures.mapIndexed((index,path) {
                //       return Container(
                //         width: MediaQuery.of(context).size.width / 3 - 15,
                //         height: 115,
                //         child: Stack(
                //           children: [
                //             // Image
                //             Positioned.fill(
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   image: DecorationImage(
                //                     image: FileImage(File(path)),
                //                     fit: BoxFit.cover,
                //                   ),
                //                   borderRadius: BorderRadius.circular(8),
                //                 ),
                //               ),
                //             ),
                //             // X icon
                //             Positioned(
                //               top: 3,
                //               left: 3,
                //               child: GestureDetector(
                //                 onTap: () {
                //                   selectedPictures.removeAt(index);
                //                   // pickedFiles.removeAt(index);
                //
                //                   setState(() {});
                //                 },
                //                 child: Icon(
                //                   Icons.cancel,
                //                   color: Orange,
                //                   size: 24,
                //                 ),
                //               ),
                //             ),
                //           ],
                //
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                //
                // Row(
                //   children: [
                //     Container(
                //       decoration: BoxDecoration(),
                //       child: ElevatedButton(
                //         style: ButtonStyle(
                //           backgroundColor:
                //           MaterialStateProperty.all<Color>(Orange),
                //         ),
                //         onPressed: _selectImages,
                //         child: Text('Select Image'),
                //       ),
                //     ),
                //     // SizedBox(width: 20,),
                //     // Container(
                //     //   decoration: BoxDecoration(),
                //     //   child: ElevatedButton(
                //     //     style: ButtonStyle(
                //     //       backgroundColor:
                //     //       MaterialStateProperty.all<Color>(Orange),
                //     //     ),
                //     //     onPressed: () {
                //     //       uploadImage(pickedFiles);
                //     //     },
                //     //     child: imageUploading
                //     //         ? const Text('Loading...')
                //     //         : const Text('Upload'),
                //     //   ),
                //     // ),
                //   ],
                // ),
                // Submit button
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Orange),
                    ),
                    onPressed: () async {
                      editCar();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SellPage()),
                      );
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        pickedFiles.forEach((pickedFile) {
          selectedPictures.add(pickedFile.path);
        });
      });
      // print("_____________________________________________________________________________________");
      // LTSImages(selectedPictures);
      // print("_____________________________________________________________________________________");
      imagesController.text = "assets/car1.jpg";
    }
  }
  // LTSImages(List img)  {
  //   img.forEach((index) {
  //     imagesController.text = index.path;
  //   });
  //   print("_____________________________________________________________________________________");
  //   print( imagesController.text);
  //   print("_____________________________________________________________________________________");
  // }
}
