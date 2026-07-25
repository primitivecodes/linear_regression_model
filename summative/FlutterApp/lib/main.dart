import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CropYieldApp());
}

class CropYieldApp extends StatelessWidget {
  const CropYieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Yield Prediction',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final areaController = TextEditingController();
  final itemController = TextEditingController();
  final yearController = TextEditingController();
  final rainfallController = TextEditingController();
  final pesticidesController = TextEditingController();
  final temperatureController = TextEditingController();

  bool loading = false;

  String result = "";

  // Chrome
  final String apiUrl = "http://127.0.0.1:8000/predict";

  // Android Emulator
  // final String apiUrl = "http://10.0.2.2:8000/predict";

  Future<void> predict() async {
    if (areaController.text.isEmpty ||
        itemController.text.isEmpty ||
        yearController.text.isEmpty ||
        rainfallController.text.isEmpty ||
        pesticidesController.text.isEmpty ||
        temperatureController.text.isEmpty) {
      setState(() {
        result = "Please fill in all fields.";
      });
      return;
    }

    setState(() {
      loading = true;
      result = "";
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "Area": areaController.text,
          "Item": itemController.text,
          "Year": int.parse(yearController.text),
          "average_rain_fall_mm_per_year":
              double.parse(rainfallController.text),
          "pesticides_tonnes":
              double.parse(pesticidesController.text),
          "avg_temp":
              double.parse(temperatureController.text),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          result =
              "Predicted Yield: ${data["predicted_yield"].toStringAsFixed(2)}";
        });
      } else {
        setState(() {
          result = "Error:\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        result = e.toString();
      });
    }

    setState(() {
      loading = false;
    });
  }

  Widget buildField(
      String label,
      TextEditingController controller,
      TextInputType type,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Yield Prediction"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            buildField(
              "Area",
              areaController,
              TextInputType.text,
            ),

            buildField(
              "Crop",
              itemController,
              TextInputType.text,
            ),

            buildField(
              "Year",
              yearController,
              TextInputType.number,
            ),

            buildField(
              "Average Rainfall",
              rainfallController,
              TextInputType.number,
            ),

            buildField(
              "Pesticides",
              pesticidesController,
              TextInputType.number,
            ),

            buildField(
              "Average Temperature",
              temperatureController,
              TextInputType.number,
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : predict,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Predict",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              result,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}