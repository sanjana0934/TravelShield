import 'package:flutter/material.dart';

class SOSPage extends StatelessWidget {
  const SOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Emergency SOS",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}