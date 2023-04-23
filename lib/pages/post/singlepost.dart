import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:realestate/models/post.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/auth.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SinglePost extends StatelessWidget {
  SinglePost({super.key, required this.id});
  final id;

  String? error = "";
  var owner = null;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: posts.doc(id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Stack(
              children: [
                Container(
                  constraints: BoxConstraints.expand(),
                ),
                Image.network(
                  data["picture"],
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 280,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data["title"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.place_outlined,
                                        size: 14,
                                      ),
                                      Text(
                                        data["location"],
                                        style: TextStyle(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Spacer(),
                              Container(
                                child: Text(
                                  "${data["price"]}\$",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 24),
                            child: Text(
                              "Desciption",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            "${data["description"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                          // Card(
                          //   elevation: 10,
                          //   margin: EdgeInsets.only(top: 24),
                          //   child: Container(
                          //     padding: EdgeInsets.all(16),
                          //     child: Column(children: [
                          //       Row(
                          //         children: [
                          //           ClipRRect(
                          //             borderRadius: BorderRadius.circular(16),
                          //             child: Container(
                          //               color: Colors.black,
                          //               child: Image.asset(
                          //                 "assets/images/villa.png",
                          //                 height: 60,
                          //                 width: 60,
                          //               ),
                          //             ),
                          //           ),
                          //           Column(children: [
                          //             Text()
                          //           ],)
                          //         ],
                          //       )
                          //     ]),
                          //   ),
                          // )
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 24),
                            child: RatingBar(
                              initialRating: 0,
                              minRating: 0,
                              maxRating: 5,
                              allowHalfRating: true,
                              itemSize: 30.0,
                              ratingWidget: RatingWidget(
                                full: const Icon(Icons.star,
                                    color: Colors.blueAccent),
                                half: const Icon(Icons.star_half,
                                    color: Colors.blueAccent),
                                empty: const Icon(Icons.star_border,
                                    color: Colors.blueAccent),
                              ),
                              onRatingUpdate: (rating) {
                                // Rating is updated
                                print('rating update to: $rating');
                              },
                            ),
                          ),
                          Text(
                            "4.8",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ],
            );
          }
          return Text("loading");
        },
      ),
    );
  }
}
