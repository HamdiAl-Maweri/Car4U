import 'package:car4u/search_page.dart';
import 'package:car4u/sell_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

// GlobalKey<FormState> formState = GlobalKey<FormState>();

class _AddCarPageState extends State<AddCarPage> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool imageUploading = false;
  List<XFile> pickedFiles = [];
  List<String> urlsOfImgs = [];

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


  List<String> selectedPictures = []; // List to store selected pictures

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
  Color selectedColor = Colors.transparent;

  CollectionReference car = FirebaseFirestore.instance.collection('car');
  bool isLoading = false;
  Future<void> addCar() async {
    if (formState.currentState!.validate()) {
      try {
        LTSImages(urlsOfImgs);
        DocumentReference responce = await car.add({
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
          'user_id': FirebaseAuth.instance.currentUser!.uid,
        });
      } catch (e) {
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Dark,
      appBar: AppBar(
        backgroundColor: White,
        title: Text(
          'Add Car',
          style: TextStyle(color: Orange),
        ),
      ),
      body: isLoading? Center(
        child: SpinKitFadingCircle (
          color: Orange,
          size: 75.0,
        ),
      ): Form(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Name';
                      }
                      if (value.length < 5) {
                        return 'Name must be at least 5 characters';
                      }
                      return null;
                    },
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Price';
                      }
                      if (int.tryParse(value)! < 500) {
                        return 'Price must be at least \$500';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Model';
                      }
                      return null;
                    },
                  ),
                ),

                // Brand field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null, // Set initial value
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Choose a car Brand';
                      }
                      return null;
                    },
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Kilometer';
                      }
                      return null;
                    },
                  ),
                ),

                // Location field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Location';
                      }
                      return null;
                    },
                  ),
                ),
                // Fuel field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null, // Set initial value
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Fuel Type';
                      }
                      return null;
                    },
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Make Year!';
                      }
                      if (int.tryParse(value)! < 1980||int.tryParse(value)! > 2024) {
                        return 'Please Enter A Valid Make Year!';
                      }
                      return null;
                    },
                  ),
                ),

                // Color field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null, // Set initial value
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Choose a car Color';
                      }
                      return null;
                    },
                  ),
                ),

                // Body field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null, // Set initial value
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please choose a car Body Type';
                      }
                      return null;
                    },
                  ),
                ),

                // Gearbox field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null, // Set initial value
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Gearbox Type';
                      }
                      return null;
                    },

                  ),
                ),

                // Cylinder field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null, // Set initial value
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please choose a car Cylinder';
                      }
                      return null;
                    },
                  ),
                ),


                // Condition field
                SizedBox(height: 16),
                Container(
                  child: DropdownButtonFormField<String>(
                    value: null, // Set initial value
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Choose a car Condition State';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a car Description';
                      }
                      return null;
                    },
                  ),
                ),


                // Images field
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 13), // Add some spacing between the icon and text
                    Icon(Icons.image_outlined, color: Orange), // Add the icon
                    SizedBox(width: 10), // Add some spacing between the icon and text
                    Text('Images',
                      style: TextStyle(color: Orange ,fontSize: 16),
                    ), // Add the text
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: White, // Set the border color
                      width: 1.0, // Set the border width
                    ),
                    borderRadius:
                        BorderRadius.circular(8), // Set the border radius
                  ),
                  child:Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: selectedPictures.mapIndexed((index,path) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 3 - 15,
                        height: 115,
                        child: Stack(
                          children: [
                            // Image
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(path)),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            // X icon
                            Positioned(
                              top: 3,
                              left: 3,
                              child: GestureDetector(
                                onTap: () {
                                  selectedPictures.removeAt(index);
                                  pickedFiles.removeAt(index);

                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Orange,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],

                        ),
                      );
                    }).toList(),
                  ),
                ),

                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Orange),
                        ),
                        onPressed: _selectImages,
                        child: Text('Select Image'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      child: selectedPictures.isEmpty ? null : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Orange),
                        ),
                        onPressed: () async{
                          uploadImage(pickedFiles);

                        },
                        child:const Text('Upload'),
                      ),
                    ),
                    Container(
                      child:!imageUploading? null : SpinKitFadingCircle (
                        color: Orange,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
                // Submit button
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Orange),
                    ),
                    onPressed: () {
                      var formdata = formState.currentState;
                      if (formdata!.validate()){
                        if (selectedPictures.isNotEmpty) {
                          isLoading = true;
                          addCar();
                          isLoading = false;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SellPage()),
                          );
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Please Upload at least One Image",style: TextStyle(fontSize:16,color:Dark),)                                  ]
                                  ),
                                ),
                                backgroundColor: White,
                                duration: Duration(milliseconds: 2000),
                                elevation: 5,

                              ));
                        }
                      }
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

    pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        selectedPictures = [];
        pickedFiles.forEach((pickedFile) {
          selectedPictures.add(pickedFile.path);
        });
      });
    }
  }

    uploadImage(List pickedFiles) {
      setState(() {
        imageUploading = true;
      });
      var imgUrl = "";
      pickedFiles.asMap().forEach((index,pickedFile) async {
        var imgName = basename(pickedFile.path);
        var reference = FirebaseStorage.instance.ref(imgName);
        await reference.putFile(File(pickedFile.path));
        imgUrl = await reference.getDownloadURL();
        urlsOfImgs.add(imgUrl);
        if(index+1 == pickedFiles.length){
          setState(() {
            imageUploading = false;
          });
        }
      });
  }
  LTSImages(List img) {
    img.forEach((index) {
      imagesController.text += index + ',';
    });
  }

}
