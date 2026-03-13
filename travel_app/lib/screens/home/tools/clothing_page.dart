import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClothingPage extends StatefulWidget {
  const ClothingPage({super.key});

  @override
  State<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {

  final TextEditingController cityController = TextEditingController();

  String weather = "";
  double temperature = 0;
  List suggestions = [];

  bool loading = false;

  Future<void> getClothingSuggestion() async {

    if (cityController.text.isEmpty) return;

    setState(() {
      loading = true;
      suggestions = [];
    });

    try {

      final response = await http.get(
        Uri.parse("http://localhost:8000/clothing_suggestion/${cityController.text}")
      );

      final data = jsonDecode(response.body);

      setState(() {

        weather = data["weather"];
        temperature = data["temperature"].toDouble();
        suggestions = data["suggestions"];

      });

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch clothing suggestions"))
      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Clothing Suggestion"),
        backgroundColor: const Color(0xFF1B5E20),
      ),

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

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              // ---------------- CITY INPUT ----------------

              TextField(

                controller: cityController,

                style: const TextStyle(color: Colors.white),

                decoration: InputDecoration(

                  hintText: "Enter Destination (Example: Munnar)",

                  hintStyle: const TextStyle(color: Colors.white70),

                  filled: true,
                  fillColor: Colors.white.withOpacity(.2),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),

                ),

              ),

              const SizedBox(height: 15),

              // ---------------- BUTTON ----------------

              ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),

                onPressed: getClothingSuggestion,

                child: const Text("Get Clothing Advice"),

              ),

              const SizedBox(height: 25),

              // ---------------- LOADING ----------------

              if (loading)
                const CircularProgressIndicator(color: Colors.white),

              // ---------------- RESULT ----------------

              if (suggestions.isNotEmpty)
                Expanded(

                  child: Container(

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),

                    ),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Weather: $weather",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Temperature: ${temperature.toStringAsFixed(1)}°C",
                          style: const TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Recommended Clothing",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(

                          child: ListView.builder(

                            itemCount: suggestions.length,

                            itemBuilder: (context, index) {

                              return ListTile(

                                leading: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),

                                title: Text(suggestions[index]),

                              );

                            },

                          ),

                        )

                      ],

                    ),

                  ),

                )

            ],

          ),

        ),

      ),

    );

  }

}