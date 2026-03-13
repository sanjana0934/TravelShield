import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("About App"),
        backgroundColor: const Color(0xFF1B5E20),
      ),

      body: const Padding(

        padding: EdgeInsets.all(20),

        child: Text(
          "Kerala Travel Assistant helps tourists explore Kerala safely.\n\n"
          "Features:\n"
          "• Fake Currency Detection\n"
          "• Malicious QR Detection\n"
          "• Trip Planner\n"
          "• Translator\n"
          "• Overprice Checker\n"
          "• SOS Emergency Support\n\n"
          "Built using Flutter + FastAPI + Machine Learning.",
          style: TextStyle(fontSize: 16),
        ),

      ),

    );
  }
}