import "package:flutter/material.dart";
import "package:realestate/widgets/forum_card.dart";

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            children: [
              Container(
                child: const Text(
                  "Chats",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: Color.fromRGBO(228, 225, 225, 1),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.search,
                  size: 28,
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(12)),
          for (int i = 0; i < 10; i++) ForumCard(),
        ],
      ),
    );
  }
}
