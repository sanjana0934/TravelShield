import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {

  bool scanned = false;

  String resultText = "Align QR code inside the frame";
  Color resultColor = Colors.white;
  IconData resultIcon = Icons.qr_code_scanner;

  final ImagePicker picker = ImagePicker();

  // ---------------- CHECK QR TEXT ----------------

  Future<void> checkQR(String text) async {

    try {

      final response = await http.post(
        Uri.parse("http://localhost:8000/check_qr"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}),
      );

      final data = jsonDecode(response.body);

      setState(() {

        scanned = true;

        if (data["result"] == "safe") {

          resultText = "SAFE QR CODE";
          resultColor = Colors.greenAccent;
          resultIcon = Icons.verified;

        } else {

          resultText = "MALICIOUS QR CODE";
          resultColor = Colors.redAccent;
          resultIcon = Icons.warning;

        }

      });

    } catch (e) {

      setState(() {

        resultText = "Server connection error";
        resultColor = Colors.orange;
        resultIcon = Icons.error;

      });

    }

  }

  // ---------------- PICK IMAGE ----------------

  Future<void> pickQRImage() async {

    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var bytes = await image.readAsBytes();

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://localhost:8000/detect_qr_image"),
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

    final data = jsonDecode(responseData);

    if (data["status"] == "success") {

      checkQR(data["text"]);

    } else {

      setState(() {

        resultText = data["message"];
        resultColor = Colors.orange;
        resultIcon = Icons.error;

      });

    }

  }

  // ---------------- RESET SCANNER ----------------

  void resetScanner() {

    setState(() {

      scanned = false;

      resultText = "Align QR code inside the frame";

      resultColor = Colors.white;

      resultIcon = Icons.qr_code_scanner;

    });

  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("QR Security Scanner"),
        backgroundColor: const Color(0xFF1B5E20),
      ),

      body: Column(

        children: [

          // ---------- CAMERA SECTION ----------

          Expanded(

            flex: 4,

            child: Stack(

              children: [

                MobileScanner(

                  onDetect: (barcodeCapture) {

                    if (scanned) return;

                    final barcodes = barcodeCapture.barcodes;

                    if (barcodes.isNotEmpty) {

                      final code = barcodes.first.rawValue;

                      if (code != null) {

                        checkQR(code);

                      }

                    }

                  },

                ),

                // ---------- SCANNER FRAME ----------

                Center(

                  child: Container(

                    width: 250,
                    height: 250,

                    decoration: BoxDecoration(

                      border: Border.all(
                        color: Colors.greenAccent,
                        width: 3,
                      ),

                      borderRadius: BorderRadius.circular(16),

                    ),

                  ),

                ),

                // ---------- TEXT GUIDE ----------

                const Positioned(

                  bottom: 25,
                  left: 0,
                  right: 0,

                  child: Text(

                    "Align QR Code inside the frame",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),

                  ),

                ),

              ],

            ),

          ),

          // ---------- RESULT PANEL ----------

          Expanded(

            flex: 2,

            child: Container(

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

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Icon(
                    resultIcon,
                    color: resultColor,
                    size: 55,
                  ),

                  const SizedBox(height: 10),

                  Text(

                    resultText,

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),

                  ),

                  const SizedBox(height: 20),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      ElevatedButton.icon(

                        icon: const Icon(Icons.refresh),

                        label: const Text("Scan Again"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),

                        onPressed: resetScanner,

                      ),

                      const SizedBox(width: 15),

                      ElevatedButton.icon(

                        icon: const Icon(Icons.image),

                        label: const Text("Pick Image"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),

                        onPressed: pickQRImage,

                      ),

                    ],

                  ),

                ],

              ),

            ),

          ),

        ],

      ),

    );

  }

}