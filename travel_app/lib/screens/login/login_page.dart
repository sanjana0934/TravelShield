import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../services/user_session.dart';
import '../home/main_navigation.dart';


// ================= BACKGROUND =================

class KeralaBackground extends StatefulWidget {
  final Widget child;

  const KeralaBackground({super.key, required this.child});

  @override
  State<KeralaBackground> createState() => _KeralaBackgroundState();
}

class _KeralaBackgroundState extends State<KeralaBackground> {

  final videos = [
    "assets/videos/video1.mp4",
    "assets/videos/video2.mp4",
    "assets/videos/video3.mp4",
    "assets/videos/video4.mp4",
    "assets/videos/video5.mp4",
    "assets/videos/video6.mp4",
  ];

  late VideoPlayerController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void loadVideo() {

    controller = VideoPlayerController.asset(videos[index])
      ..initialize().then((_) {

        controller.setVolume(0);
        controller.play();

        controller.addListener(() {

          if (controller.value.position >= controller.value.duration) {

            index = (index + 1) % videos.length;

            controller.dispose();

            loadVideo();

          }

        });

        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {

    if (!controller.value.isInitialized) {
      return const SizedBox();
    }

    return Stack(

      children: [

        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x552E7D32),
                Color(0x5539A0ED),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        widget.child,

      ],

    );
  }

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    super.dispose();
  }
}


// ================= LOGIN =================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> login() async {

    final response = await http.post(

      Uri.parse("http://127.0.0.1:8000/login"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "email": email.text,
        "password": password.text
      }),

    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success") {

      UserSession.setUser(data["user"]);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"])),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: KeralaBackground(

        child: Center(

          child: glassCard(

            Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                Image.asset(
                  "assets/images/kathakali.png",
                  height: 120,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Explore Kerala With Us",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text("God’s Own Country 🌊"),

                const SizedBox(height: 25),

                field("Email", controller: email),

                field(
                  "Password",
                  hide: true,
                  controller: password,
                ),

                actionButton("LOGIN", login),

                TextButton(

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );

                  },

                  child: const Text("New Tourist? Register"),

                )

              ],
            ),

          ),

        ),

      ),

    );
  }
}


// ================= REGISTER =================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final first = TextEditingController();
  final middle = TextEditingController();
  final last = TextEditingController();
  final phone = TextEditingController();
  final emergency = TextEditingController();
  final nationality = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  String gender = "Male";
  String blood = "O+";
  DateTime? dob;

  Future<void> signup() async {

    if (dob == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select DOB")));

      return;
    }

    if (password.text != confirm.text) {

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match")));

      return;
    }

    final response = await http.post(

      Uri.parse("http://127.0.0.1:8000/signup"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({

        "first_name": first.text,
        "middle_name": middle.text,
        "last_name": last.text,
        "gender": gender,
        "dob": dob.toString(),
        "phone": phone.text,
        "emergency_contact": emergency.text,
        "nationality": nationality.text,
        "address": address.text,
        "blood_group": blood,
        "email": email.text,
        "password": password.text

      }),

    );

    final data = jsonDecode(response.body);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(data["message"])));

    if (data["status"] == "success") {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: KeralaBackground(

        child: Center(

          child: glassCard(

            SingleChildScrollView(

              child: Column(

                children: [

                  const Text(
                    "New User Registration",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  field("First Name", controller: first),
                  field("Middle Name", controller: middle),
                  field("Last Name", controller: last),

                  dropdown("Gender", ["Male","Female","Other"], (v) {
                    gender = v!;
                  }),

                  datePicker(),

                  field("Phone", controller: phone),
                  field("Emergency Contact", controller: emergency),
                  field("Nationality", controller: nationality),
                  field("Address", controller: address),

                  dropdown("Blood Group",
                      ["O+","O-","A+","A-","B+","B-","AB+","AB-"], (v) {
                    blood = v!;
                  }),

                  field("Email", controller: email),
                  field("Password", hide: true, controller: password),
                  field("Confirm Password", hide: true, controller: confirm),

                  const SizedBox(height: 15),

                  actionButton("CREATE ACCOUNT", signup),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget datePicker() {

    return ListTile(

      title: Text(
        dob == null ? "Select Date of Birth" : dob.toString().split(" ")[0],
      ),

      trailing: const Icon(Icons.calendar_today),

      onTap: () async {

        final picked = await showDatePicker(

          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),

        );

        if (picked != null) {

          setState(() {
            dob = picked;
          });

        }

      },

    );
  }
}


// ================= UI HELPERS =================

Widget glassCard(Widget child) {

  return ClipRRect(
    borderRadius: BorderRadius.circular(22),

    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),

      child: Container(

        width: 360,
        padding: const EdgeInsets.all(25),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.85),
          borderRadius: BorderRadius.circular(22),
        ),

        child: child,

      ),
    ),
  );
}

Widget field(String label,
    {bool hide = false, TextEditingController? controller}) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),

    child: TextField(
      controller: controller,
      obscureText: hide,

      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

      ),

    ),

  );
}

Widget dropdown(String label, List<String> items, Function(String?) onChange) {

  String value = items.first;

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),

    child: DropdownButtonFormField(

      value: value,

      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),

      onChanged: onChange,

      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

      ),

    ),

  );
}

Widget actionButton(String text, VoidCallback onTap) {

  return SizedBox(

    width: double.infinity,

    child: ElevatedButton(

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.all(14),
      ),

      onPressed: onTap,

      child: Text(text),

    ),

  );
}