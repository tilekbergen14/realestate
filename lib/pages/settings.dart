import 'package:flutter/material.dart';
import 'package:realestate/pages/auth.dart';
import 'package:realestate/widgets/forum_card.dart';

import '../widgets/settings_card_item.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

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
                  "Settings",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                },
                child: Text("Login"),
              )
            ],
          ),
          Column(
            children: [
              const Padding(padding: EdgeInsets.all(12)),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black,
                  child: Image.asset(
                    "assets/images/villa.png",
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  "Kokpan Merei",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            elevation: 2,
            child: Column(
              children: const [
                Settings_Card_Item(
                  title: "Profile",
                  icon: Icon(Icons.settings),
                ),
                Settings_Card_Item(
                  title: "Notifications",
                  icon: Icon(Icons.notifications),
                ),
                Settings_Card_Item(
                  title: "Change Password",
                  icon: Icon(Icons.lock_outline),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            elevation: 10,
            child: Column(
              children: const [
                Settings_Card_Item(
                  title: "Profile",
                  icon: Icon(Icons.settings),
                ),
                Settings_Card_Item(
                  title: "Notifications",
                  icon: Icon(Icons.notifications),
                ),
                Settings_Card_Item(
                  title: "Change Password",
                  icon: Icon(Icons.lock_outline),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            elevation: 2,
            child: Column(
              children: const [
                Settings_Card_Item(
                  title: "Profile",
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
