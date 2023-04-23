import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realestate/pages/post/singlepost.dart';
import 'package:realestate/theme/color.dart';
import 'package:realestate/utils/data.dart';
import 'package:realestate/widgets/category_item.dart';
import 'package:realestate/widgets/custom_image.dart';
import 'package:realestate/widgets/custom_textbox.dart';
import 'package:realestate/widgets/icon_box.dart';
import 'package:realestate/widgets/property_item.dart';
import 'package:realestate/widgets/recent_item.dart';
import 'package:realestate/widgets/recommend_item.dart';

import 'post/createpost.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
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
        SliverToBoxAdapter(child: getBody()),
      ],
    );
  }

  getHeader() {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Салем!",
                    style: TextStyle(
                        color: darker,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Мерей",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePost(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF2ecc71),
                  ),
                  child: Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                    child: CustomTextBox(
                  hint: "Іздеу",
                  prefix: Icon(Icons.search, color: Colors.grey),
                )),
                SizedBox(
                  width: 10,
                ),
                IconBox(
                  child: Icon(Icons.filter_list_rounded, color: Colors.white),
                  bgColor: secondary,
                  radius: 10,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 0),
            child: listCategories(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Танымал",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Барлыған көру",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          listPopulars(),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ұсыныстар",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Барлыған көру",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          listRecommended(),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Соңғылар",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Барлыған көру",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          listRecent(),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  int selectedCategory = 0;
  listCategories() {
    List<Widget> lists = List.generate(
        categories.length,
        (index) => CategoryItem(
              data: categories[index],
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

  listPopulars() {
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
          return Text("Loading");
        }
        return CarouselSlider(
          options: CarouselOptions(
            height: 240,
            enlargeCenterPage: true,
            disableCenter: true,
            viewportFraction: .8,
          ),
          items: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SinglePost(id: document.id)),
                );
              },
              child: PropertyItem(data: {
                "image": data["picture"],
                "name": data["title"],
                "price": "${data["price"]}",
                "location": data["location"],
                "is_favorited": true,
              }),
            );
          }).toList(),
        );
      },
    );
  }

  listRecommended() {
    List<Widget> lists = List.generate(
        recommended.length, (index) => RecommendItem(data: recommended[index]));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  listRecent() {
    List<Widget> lists = List.generate(
        recents.length, (index) => RecentItem(data: recents[index]));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }
}
