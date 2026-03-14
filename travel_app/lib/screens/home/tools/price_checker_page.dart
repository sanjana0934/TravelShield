import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceCheckerPage extends StatefulWidget {
  const PriceCheckerPage({super.key});

  @override
  State<PriceCheckerPage> createState() => _PriceCheckerPageState();
}

class _PriceCheckerPageState extends State<PriceCheckerPage> {

  String service = "taxi_per_km";

  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String result = "";

  Future<void> checkPrice() async {

    if (priceController.text.isEmpty || quantityController.text.isEmpty) {
      setState(() {
        result = "Please enter price and quantity.";
      });
      return;
    }

    double chargedPrice = double.parse(priceController.text);
    int quantity = int.parse(quantityController.text);

    try {

      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/assistant/price-check"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "service": service,
          "charged_price": chargedPrice,
          "quantity": quantity
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {

        result =
            "Expected Price: ₹${data["expected_price"]}\nStatus: ${data["price_status"]}";

      });

    } catch (e) {

      setState(() {
        result = "Connection error. Check backend.";
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.green,

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Price Checker",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Center(

        child: Container(

          width: 450,
          padding: const EdgeInsets.all(25),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              const Text(
                "Check Overpricing",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField(

                value: service,

                items: const [

                  DropdownMenuItem(
                    value: "taxi_per_km",
                    child: Text("Taxi (per km)"),
                  ),

                  DropdownMenuItem(
                    value: "auto_per_km",
                    child: Text("Auto Rickshaw (per km)"),
                  ),

                  DropdownMenuItem(
                    value: "bus_ticket",
                    child: Text("Bus Ticket"),
                  ),

                  DropdownMenuItem(
                    value: "museum_entry",
                    child: Text("Museum Entry"),
                  ),

                ],

                onChanged: (value) {

                  setState(() {
                    service = value.toString();
                  });

                },

                decoration: const InputDecoration(
                  labelText: "Select Service",
                ),

              ),

              const SizedBox(height: 15),

              TextField(

                controller: priceController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Charged Price (₹)",
                ),

              ),

              const SizedBox(height: 15),

              TextField(

                controller: quantityController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Quantity (km / tickets / people)",
                ),

              ),

              const SizedBox(height: 25),

              ElevatedButton(

                onPressed: checkPrice,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12
                  ),
                ),

                child: const Text(
                  "Check Price",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),

              ),

              const SizedBox(height: 20),

              Text(
                result,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}