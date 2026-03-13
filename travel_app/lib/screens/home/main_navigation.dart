import 'package:flutter/material.dart';
import '../sos/sos_page.dart';
import '../profile/profile_page.dart';
import 'home_page.dart';
import '../../drawer/app_drawer.dart';

// ← REMOVED trip_planner import

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final pages = [
    const HomePage(),
    // ← REMOVED TripPlannerPage()
    const SOSPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: pages[index],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 20,
            )
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1B5E20),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            // ← REMOVED Trip Planner item
            BottomNavigationBarItem(
              icon: Icon(Icons.warning_amber_rounded),
              label: "SOS",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}