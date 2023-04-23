import 'package:flutter/material.dart';
import 'package:realestate/pages/auth.dart';
import 'package:realestate/pages/profile.dart';
import 'package:realestate/pages/root.dart';
import 'package:realestate/widgets/forum_card.dart';

import '../models/auth.dart';
import '../widgets/settings_card_item.dart';
import 'forum.dart';
import 'home.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = Auth().currentUser;
  final email = Auth().currentUser?.email;

  @override
  void initState() {
    // print("Hello $user");
    super.initState();
  }

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
                  if (Auth().currentUser != null) {
                    Auth().signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RootApp()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                  }
                },
                child: user != null ? Text("Logout") : Text("Login"),
              )
            ],
          ),
          if (user != null)
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
                  child: Text(
                    "$email",
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
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  child: Settings_Card_Item(
                    title: "Profile",
                    icon: Icon(Icons.person),
                  ),
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
