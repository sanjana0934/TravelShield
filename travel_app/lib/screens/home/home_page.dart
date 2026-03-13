import 'package:flutter/material.dart';
import '../../services/user_session.dart';
import '../../data/destinations.dart';
import '../../drawer/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final userName =
        UserSession.currentUser["first_name"] ?? "Explorer";

    return Scaffold(

      drawer: const AppDrawer(),

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

                // ---------------- HEADER ----------------

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [

                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Hello $userName 👋",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "Discover beautiful places in Kerala",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),

                    const CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          AssetImage("assets/images/profile.jpg"),
                    )

                  ],
                ),

                const SizedBox(height: 25),

                // ---------------- SEARCH BAR ----------------

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),

                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search destinations",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // ---------------- DESTINATIONS TITLE ----------------

                const Text(
                  "Popular Destinations",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // ---------------- DESTINATIONS LIST ----------------

                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: destinations.length,

                    itemBuilder: (context, index) {

                      final place = destinations[index];

                      return DestinationCard(
                        title: place.name,
                        image: place.image,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------- FEATURE BANNER ----------------

                Container(
                  height: 180,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/munnar.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),

                  child: Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black54
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),

                    alignment: Alignment.bottomLeft,

                    child: const Text(
                      "Explore Munnar",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class DestinationCard extends StatelessWidget {

  final String title;
  final String image;

  const DestinationCard({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],

        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          gradient: const LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black54
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}