import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  String? error = "";
  bool _isLoading = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = Auth().currentUser;
  // final image = FirebaseFirestore.instance.collection("users").doc(user?.uid);
  final username = TextEditingController();
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
    uploadFile();
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(user?.uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      data["profile"] != ""
                          ? InkWell(
                              onTap: () {
                                getImage(ImageSource.gallery);
                              },
                              child: Image.network(data["profile"]),
                            )
                          : InkWell(
                              onTap: () {
                                getImage(ImageSource.gallery);
                              },
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: image != null
                                    ? AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            //to show image, you type like this.
                                            File(image!.path),
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 300,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        color: Colors.grey[300],
                                        child: Text("Upload image"),
                                      ),
                              ),
                            ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 16),
                        child: Text(
                          "${user?.email}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: TextField(
                          controller: username,
                          decoration: InputDecoration(
                              hintText: data["username"] != ""
                                  ? data["username"]
                                  : "Username"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          onPressed: () {
                            update();
                            Navigator.pop(context);
                          },
                          child: Text("Update"),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
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
        ],
      ),
    );
  }

  Future update() async {
    try {
      setState(() {
        error = "";
        _isLoading = true;
      });
      final db = FirebaseFirestore.instance;

      await db
          .collection('users')
          .doc(user?.uid)
          .set({"profile": pic, "username": username.text});

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
