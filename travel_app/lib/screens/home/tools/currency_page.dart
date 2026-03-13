import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {

  double probability = 0;
  String prediction = "No scan yet";
  Color resultColor = Colors.white;
  bool isLoading = false;

  Future<void> pickImage() async {

    try {

      final picker = ImagePicker();

      final XFile? image =
          await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        isLoading = true;
        prediction = "Scanning...";
      });

      // Read image as bytes (important for Flutter Web)
      var bytes = await image.readAsBytes();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://localhost:8000/detect_currency"),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          bytes,
          filename: image.name,
        ),
      );

      var response = await request.send();

      var responseData = await response.stream.bytesToString();

      print(responseData);

      final data = jsonDecode(responseData);

      if (data["status"] == "success") {

        double realProb = (data["real_probability"] ?? 0) / 100;

        setState(() {

          probability = realProb.clamp(0.0, 1.0);

          prediction = data["prediction"] ?? "Unknown";

          resultColor =
              prediction == "Real Note" ? Colors.green : Colors.red;

        });

      } else {

        setState(() {
          prediction = "Detection failed";
          resultColor = Colors.orange;
        });

      }

    } catch (e) {

      print("ERROR: $e");

      setState(() {
        prediction = "Error connecting to server";
        resultColor = Colors.orange;
      });

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Currency Authenticity Scanner"),
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

        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.currency_rupee,
                size: 80,
                color: Colors.white,
              ),

              const SizedBox(height: 30),

              CircularPercentIndicator(
                radius: 120,
                lineWidth: 14,
                percent: probability,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: resultColor,
                backgroundColor: Colors.white24,
                center: Text(
                  "${(probability * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                prediction,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),

              const SizedBox(height: 35),

              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton.icon(

                      icon: const Icon(Icons.upload),

                      label: const Text("Upload Currency Image"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                      ),

                      onPressed: pickImage,
                    ),

            ],
          ),
        ),
      ),
    );
  }
}