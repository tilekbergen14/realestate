import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateHouse extends StatefulWidget {
  const RateHouse({super.key});

  @override
  State<RateHouse> createState() => _RateHouseState();
}

class _RateHouseState extends State<RateHouse> {
  final adress = TextEditingController();
  final size = TextEditingController();
  final floorNum = TextEditingController();
  final yearbuilt = TextEditingController();
  String? error = "";
  bool _isLoading = false;
  bool? balcony = false;
  bool? remont = false;
  bool? water = false;
  bool? power = false;
  double rating = 3;
  int price = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Үйді бағалау!",
                style: TextStyle(fontSize: 21),
              ),
            ),
            Text(
              "$error",
              style: TextStyle(color: Colors.red),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: adress,
                decoration: const InputDecoration(
                  hintText: "Адрес",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: size,
                decoration: const InputDecoration(
                  hintText: "м²",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: yearbuilt,
                decoration: const InputDecoration(
                  hintText: "Үйдің салынған жылы",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: floorNum,
                decoration: const InputDecoration(
                  hintText: "Этаж",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            CheckboxListTile(
                title: Text("Ремонт"),
                //only check box
                value: remont, //unchecked
                onChanged: (bool? value) {
                  //value returned when checkbox is clicked
                  setState(() {
                    remont = value;
                  });
                }),
            CheckboxListTile(
                title: Text("Балкон"),
                //only check box
                value: balcony, //unchecked
                onChanged: (bool? value) {
                  //value returned when checkbox is clicked
                  setState(() {
                    balcony = value;
                  });
                }),
            CheckboxListTile(
                title: Text("Су"),
                //only check box
                value: water, //unchecked
                onChanged: (bool? value) {
                  //value returned when checkbox is clicked
                  setState(() {
                    water = value;
                  });
                }),
            CheckboxListTile(
                title: Text("Тоқ"),
                //only check box
                value: power, //unchecked
                onChanged: (bool? value) {
                  //value returned when checkbox is clicked
                  setState(() {
                    power = value;
                  });
                }),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  price = 0;
                });
                Timer(Duration(seconds: 3), () => calculate());
              },
              child: Text("Бағалау"),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              alignment: Alignment.center,
              child: Text(
                price != 0 ? "$price〒" : "",
                style: TextStyle(fontSize: 21),
              ),
            ),
            if (rating != 3)
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 24),
                child: RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // print(rating);
                  },
                ),
              ),
          ]),
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

  calculate() {
    if (size.text == "" ||
        floorNum.text == "" ||
        adress.text == "" ||
        yearbuilt.text == "") {
      setState(() {
        error = "Қажетті параметрлерді жазыңыз!";
        _isLoading = false;
      });
    } else {
      int nu = locations[adress.text.toLowerCase()]?.toInt() ?? 0;
      int result = int.parse(size.text) * 473600 +
          (6000000 - ((2023 - int.parse(yearbuilt.text)) * 500000)) +
          (100000 * int.parse(floorNum.text)) +
          nu;
      rating = 3;
      if (remont != true) {
        result -= 5000000;
      } else {
        rating += 0.5;
      }
      if (balcony == true) {
        result += 750000;
        rating += 0.5;
      }
      if (power == true) {
        result += 750000;
        rating += 0.5;
      }
      if (water == true) {
        result += 750000;
        rating += 0.5;
      }
      print(rating);
      setState(() {
        error = "";
        price = result;
        _isLoading = false;
      });
    }
  }

  var locations = {
    "almaty": 6000000,
    "pushkin": 2000000,
    "turkistan": 6000000,
    "turan": 7000000,
    "najmedinov": 5000000,
    "khajimukhan": 3000000,
  };
}


//m.kv
//address
//etaj
//ui salingan jil
