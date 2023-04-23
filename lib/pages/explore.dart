import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realestate/pages/post/singlepost.dart';
import 'package:realestate/theme/color.dart';
import 'package:realestate/utils/data.dart';
import 'package:realestate/widgets/broker_item.dart';
import 'package:realestate/widgets/company_item.dart';
import 'package:realestate/widgets/custom_textbox.dart';
import 'package:realestate/widgets/icon_box.dart';
import 'package:realestate/widgets/recommend_item.dart';

import '../widgets/property_item.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  final searchkey = TextEditingController();
  String word = "";
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: appBgColor,
          pinned: true,
          snap: true,
          floating: true,
          title: getHeader(),
        ),
        SliverToBoxAdapter(child: getBody())
      ],
    );
  }

  getHeader() {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 3),
            height: 40,
            decoration: BoxDecoration(
              color: textBoxColor,
              border: Border.all(color: textBoxColor),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.05),
                  spreadRadius: .5,
                  blurRadius: .5,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: TextField(
              controller: searchkey,
              onChanged: (val) {
                setState(() {
                  word = val;
                  print(word);
                });
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        IconBox(
          child: Icon(Icons.filter_list_rounded, color: Colors.white),
          bgColor: secondary,
          radius: 10,
        )
      ],
    );
  }

  getBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Matched Properties",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          listRecommended(),
          SizedBox(
            height: 20,
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 15, right: 15),
          //   child: Text(
          //     "Companies",
          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          //   ),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // listCompanies(),
          // SizedBox(
          //   height: 20,
          // ),
          // listBrokers(),
          // SizedBox(
          //   height: 100,
          // ),
        ],
      ),
    );
  }

  listRecommended() {
    final Stream<QuerySnapshot> postsStream =
        FirebaseFirestore.instance.collection('posts').snapshots();
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return StreamBuilder<QuerySnapshot>(
      stream: postsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          children: snapshot.data!.docs.map(
            (DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              if (data["title"]
                  .toString()
                  .toLowerCase()
                  .startsWith(searchkey.text.toLowerCase())) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SinglePost(id: document.id)),
                    );
                  },
                  child: RecommendItem(
                    data: {
                      "image": data["picture"],
                      "name": data["title"],
                      "price": "${data["price"]}",
                      "location": data["location"],
                      "is_favorited": true,
                    },
                    width: double.infinity,
                    height: 200,
                  ),
                );
              } else {
                Text("No matches found!");
              }
              return Container();
            },
          ).toList(),
        );
      },
    );
  }

  int selectedCategory = 0;
  listCompanies() {
    List<Widget> lists = List.generate(
        companies.length,
        (index) => CompanyItem(
              data: companies[index],
              color: listColors[index % 10],
              selected: index == selectedCategory,
              onTap: () {
                setState(() {
                  selectedCategory = index;
                });
              },
            ));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  listBrokers() {
    List<Widget> lists = List.generate(
        brokers.length, (index) => BrokerItem(data: brokers[index]));

    return Container(
      margin: EdgeInsets.only(right: 15, left: 15),
      child: Column(children: lists),
    );
  }
}
