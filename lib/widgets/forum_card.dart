import "package:flutter/material.dart";

class ForumCard extends StatelessWidget {
  const ForumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/house.png"),
                  radius: 32,
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Пайдаланушы",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        Text(
                          "Соңғы жазылған текст",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.visibility_off),
                        Text(
                          "1 min",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
