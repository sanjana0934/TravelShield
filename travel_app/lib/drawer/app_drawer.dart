import 'package:flutter/material.dart';
import '../../services/user_session.dart';
import '../screens/chatbot/chatbot_screen.dart';
import '../screens/alerts/district_alert_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final user = UserSession.currentUser;

    final String name =
        user["first_name"] ?? user["name"] ?? "Traveler";

    final String email =
        user["email"] ?? "guest@travel.com";

    return Drawer(

      child: ListView(

        padding: EdgeInsets.zero,

        children: [

          // ---------------- HEADER ----------------

          Container(

            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 20,
            ),

            decoration: const BoxDecoration(

              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F3D2E),
                  Color(0xFF1B5E20),
                  Color(0xFF4CAF50),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

            ),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Icon(
                  Icons.travel_explore,
                  size: 40,
                  color: Colors.white,
                ),

                const SizedBox(height: 10),

                const Text(
                  "Kerala Travel Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF1B5E20),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),

                      ],
                    )

                  ],
                ),

              ],

            ),

          ),

          const SizedBox(height: 10),

          // ---------------- AI FEATURES ----------------

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "AI FEATURES",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.currency_exchange, color: Colors.green),
            title: const Text("Currency Checker"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/currency");
            },
          ),

          ListTile(
            leading: const Icon(Icons.qr_code_scanner, color: Colors.green),
            title: const Text("QR Scanner"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/qr");
            },
          ),

          // ----------- CLOTHING SUGGESTION -----------

          ListTile(
            leading: const Icon(Icons.checkroom, color: Colors.green),
            title: const Text("Clothing Suggestion"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/clothing");
            },
          ),

          ListTile(
            leading: const Icon(Icons.translate, color: Colors.green),
            title: const Text("Translator"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/translator");
            },
          ),

          ListTile(
            leading: const Icon(Icons.attach_money, color: Colors.green),
            title: const Text("Overprice Checker"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/price");
            },
          ),

          const Divider(),

          // ---------------- TRAVEL ----------------

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "TRAVEL",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.map, color: Colors.teal),
            title: const Text("Trip Planner"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/trip");
            },
          ),

          ListTile(
  leading: const Icon(Icons.newspaper, color: Colors.teal),
  title: const Text("TravelShield Alerts"),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
      builder: (_) =>  DistrictAlertScreen()));
  },
),

         ListTile(
  leading: const Icon(Icons.chat, color: Colors.teal),
  title: const Text("Tourist Chatbot"),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
  },
),
          const Divider(),

          // ---------------- SAFETY ----------------

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "SAFETY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.emergency, color: Colors.red),
            title: const Text("SOS Emergency"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/sos");
            },
          ),

          const Divider(),

          // ---------------- OTHER ----------------

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/settings");
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/about");
            },
          ),

          const SizedBox(height: 10),

        ],

      ),

    );

  }

}