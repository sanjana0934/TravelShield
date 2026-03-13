import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool notifications = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF1B5E20),
      ),

      body: ListView(

        children: [

          const SizedBox(height: 10),

          const ListTile(
            title: Text(
              "APP SETTINGS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          SwitchListTile(

            title: const Text("Enable Notifications"),

            subtitle: const Text("Receive travel alerts"),

            value: notifications,

            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },

          ),

          SwitchListTile(

            title: const Text("Dark Mode"),

            subtitle: const Text("Reduce eye strain"),

            value: darkMode,

            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },

          ),

          const Divider(),

          const ListTile(
            title: Text(
              "APP INFO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text("Version"),
            subtitle: Text("1.0.0"),
          ),

          const ListTile(
            leading: Icon(Icons.security),
            title: Text("Privacy Policy"),
          ),

          const ListTile(
            leading: Icon(Icons.description),
            title: Text("Terms & Conditions"),
          ),

        ],

      ),

    );
  }
}