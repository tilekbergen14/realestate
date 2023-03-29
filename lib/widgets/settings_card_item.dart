import 'package:flutter/material.dart';

class Settings_Card_Item extends StatelessWidget {
  final String title;
  final Widget icon;
  const Settings_Card_Item(
      {super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              child: icon,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 186, 185, 185),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    size: 32,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
