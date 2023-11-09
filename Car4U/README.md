# car4u

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
//"mobilesdk_app_id": "1:193794055399:android:300ad3a07ebda671b49642",


    try {
      FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://test-193e1.appspot.com');
      StorageReference ref = storage.ref().child(selectedPictures[0].path);
      StorageUploadTask storageUploadTask = ref.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('success'),
      ));
      String url = await taskSnapshot.ref.getDownloadURL();
      print('url $url');
      setState(() {
        _url = url;
      });
    } catch (ex) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(ex.message),
      ));
    }




Future<void> _selectImages() async {
final picker = ImagePicker();
final pickedFiles = await picker.pickImage(source: ImageSource.gallery);
if (pickedFiles != null ) {
setState(() {
// pickedFiles.forEach((pickedFile) {
//   selectedPictures.add(pickedFile.path);
// });
});
print("_____________________________________________________________________________________0");

      print("_____________________________________________________________________________________1");
      uploadImage(pickedFiles);
      print("_____________________________________________________________________________________2");
      imagesController.text = "assets/car1.jpg";
    }
    // return pickedFiles;
}

void uploadImage(XFile pickedFiles) async{
print("_____________________________________________________________________________________3");
// pickedFiles.forEach((pickedFile) async {
var imgName = basename(pickedFiles.path);
var reference = FirebaseStorage.instance.ref(imgName);
await reference.putFile(pickedFiles as File);
print("_____________________________________________________________________________________4");
// })




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