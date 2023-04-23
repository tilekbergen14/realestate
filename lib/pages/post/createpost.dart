import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:realestate/models/post.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/auth.dart';
import 'dart:io';
// import '../models/words.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final title = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();
  final price = TextEditingController();
  final ownerId = Auth().currentUser;
  String type = "";
  String? error = "";
  bool _isLoading = false;

  @override
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
    uploadFile();
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String pic = "";

  Future uploadFile() async {
    final path = "files/${image?.name}";
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);
    setState(() {
      pic = urlDownload;
    });
  }

  String dropdownvalue = "Villa";
  List<String> types = ["Villa", "Shop", "Building", "House"];

  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              image != null
                  ? InkWell(
                      onTap: () {
                        myAlert();
                      },
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        myAlert();
                      },
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Text(
                            "No Image",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
              Text(
                "$error",
                style: TextStyle(color: Colors.red),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    hintText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: price,
                  decoration: const InputDecoration(
                    hintText: "Price",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: description,
                  decoration: const InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              DropdownButton(
                // Initial Value
                value: dropdownvalue,
                isExpanded: true,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: types.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  CreatePost();
                },
                child: Text("Add new"),
              ),

              SizedBox(
                height: 10,
              ),
              //if image not null show the image
              //if image null show text
            ],
          ),
        ),
      ),
      if (_isLoading)
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
      if (_isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
    ]);
  }

  Future<void> CreatePost() async {
    try {
      setState(() {
        error = "";
        _isLoading = true;
      });
      final db = FirebaseFirestore.instance;
      Post post = Post(
          title: title.text,
          description: description.text,
          location: location.text,
          price: int.parse(price.text),
          ownerId: ownerId!.uid,
          picture: pic,
          id: "",
          type: dropdownvalue);
      await db
          .collection('posts')
          .add({'createdAt': DateTime.now(), ...post.toJson()});
      setState(() {
        error = "";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        print(e);
        error = e.toString();
        _isLoading = false;
      });
    }
  }
}
