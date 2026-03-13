import 'package:flutter/material.dart';

class TranslatorPage extends StatelessWidget {
  const TranslatorPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Translator"),
      ),

      body: const Center(
        child: Text(
          "Translator Feature Coming Soon",
          style: TextStyle(fontSize: 20),
        ),
      ),

    );
  }
}