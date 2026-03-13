import 'package:flutter/material.dart';
import '../../services/user_session.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    final user = UserSession.currentUser;

    final fullName = [
      user["first_name"],
      user["middle_name"],
      user["last_name"]
    ].where((e) => e != null && e.toString().isNotEmpty).join(" ");

    return Scaffold(

      body: Container(

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

        child: SafeArea(

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                // PROFILE HEADER

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.15),
                        blurRadius: 10,
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green,
                        child: Text(
                          (user["first_name"] ?? "U")[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            user["nationality"] ?? "",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),

                        ],
                      )

                    ],
                  ),
                ),

                const SizedBox(height: 30),

                sectionTitle("Personal Information"),

                infoTile(Icons.person, "Gender", user["gender"]),
                infoTile(Icons.cake, "Date of Birth", user["dob"]),
                infoTile(Icons.bloodtype, "Blood Group", user["blood_group"]),

                const SizedBox(height: 25),

                sectionTitle("Contact Information"),

                infoTile(Icons.email, "Email", user["email"]),
                infoTile(Icons.phone, "Phone", user["phone"]),
                infoTile(Icons.warning, "Emergency Contact", user["emergency_contact"]),
                infoTile(Icons.location_on, "Address", user["address"]),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    onPressed: () {

                      UserSession.clear();
                      Navigator.pushReplacementNamed(context, "/login");

                    },

                    child: const Text("Logout"),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget sectionTitle(String title) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget infoTile(IconData icon, String title, dynamic value) {

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(15),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.12),
          blurRadius: 6,
        )
      ],
    ),

    child: Row(
      children: [

        Icon(icon, color: Colors.green),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value?.toString() ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ],
          ),
        )

      ],
    ),
  );
}
