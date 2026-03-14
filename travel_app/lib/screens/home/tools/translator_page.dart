import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  final TextEditingController textController = TextEditingController();
  final stt.SpeechToText speech = stt.SpeechToText();

  String translatedText = "";
  bool isListening = false;

  String direction = "en_ml";

  //----------------------------------------
  // TRANSLATE TEXT
  //----------------------------------------

  Future<void> translateText() async {
    String text = textController.text.trim();
    if (text.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/assistant/translate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "text": text,
          "lang": direction == "ml_en" ? "en" : "ml"
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        translatedText = data["translated_text"];
      });
    } catch (e) {
      setState(() {
        translatedText = "Connection error. Check backend.";
      });
    }
  }

  //----------------------------------------
  // START SPEECH
  //----------------------------------------

  void startListening() async {
    bool available = await speech.initialize();
    if (!available) return;

    setState(() {
      isListening = true;
    });

    String speechLang = direction == "ml_en" ? "ml-IN" : "en-US";

    speech.listen(
      localeId: speechLang,
      onResult: (result) {
        setState(() {
          textController.text = result.recognizedWords;
        });
      },
    );
  }

  //----------------------------------------
  // STOP SPEECH
  //----------------------------------------

  void stopListening() {
    speech.stop();
    setState(() {
      isListening = false;
    });
  }

  //----------------------------------------
  // UI
  //----------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff66bb6a),
              Color(0xff26a69a),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //----------------------------------------
                // TITLE
                //----------------------------------------

                const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.language, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "Language Translator",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //----------------------------------------
                // LANGUAGE DIRECTION
                //----------------------------------------

                const Text(
                  "Language Direction",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff3f3f3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: direction,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: "en_ml",
                        child: Text("English → Malayalam"),
                      ),
                      DropdownMenuItem(
                        value: "ml_en",
                        child: Text("Malayalam → English"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        direction = value!;
                        translatedText = "";
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

                //----------------------------------------
                // INPUT TEXT
                //----------------------------------------

                const Text(
                  "Enter Text",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: textController,
                  maxLines: 3,
                  onTap: () {
                    setState(() {
                      translatedText = "";
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xfff3f3f3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                //----------------------------------------
                // BUTTONS
                //----------------------------------------

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        isListening ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      label: Text(
                        isListening ? "Stop" : "Speak",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3b82f6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (isListening) {
                          stopListening();
                        } else {
                          startListening();
                        }
                      },
                    ),

                    const SizedBox(width: 20),

                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.translate,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Translate",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3b82f6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: translateText,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                //----------------------------------------
                // OUTPUT
                //----------------------------------------

                const Text(
                  "Translated Text",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xfff3f3f3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    translatedText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}