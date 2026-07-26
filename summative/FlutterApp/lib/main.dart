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
    const seedColor = Color(0xFF2F7D4A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Yield Prediction',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8F3),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD5E2D4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD5E2D4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: seedColor, width: 2),
          ),
        ),
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
  String result = '';

  // Production API
  final String apiUrl =
      'https://linear-regression-model-y3qw.onrender.com/predict';

  // Android Emulator
  // final String apiUrl = "http://10.0.2.2:8000/predict";

  @override
  void dispose() {
    areaController.dispose();
    itemController.dispose();
    yearController.dispose();
    rainfallController.dispose();
    pesticidesController.dispose();
    temperatureController.dispose();
    super.dispose();
  }

  Future<void> predict() async {
    if (areaController.text.isEmpty ||
        itemController.text.isEmpty ||
        yearController.text.isEmpty ||
        rainfallController.text.isEmpty ||
        pesticidesController.text.isEmpty ||
        temperatureController.text.isEmpty) {
      setState(() => result = 'Please fill in all fields.');
      return;
    }

    setState(() {
      loading = true;
      result = '';
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Area': areaController.text,
          'Item': itemController.text,
          'Year': int.parse(yearController.text),
          'average_rain_fall_mm_per_year':
              double.parse(rainfallController.text),
          'pesticides_tonnes': double.parse(pesticidesController.text),
          'avg_temp': double.parse(temperatureController.text),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result = 'Predicted Yield: '
              '${data['predicted_yield'].toStringAsFixed(2)}';
        });
      } else {
        setState(() => result = 'Error:\n${response.body}');
      }
    } catch (e) {
      setState(() => result = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required TextInputType type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: type,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  bool get _hasSuccessfulResult => result.startsWith('Predicted Yield:');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(color: Color(0xFFE1EADF)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crop conditions',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Enter the growing conditions to estimate yield.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xFF607064)),
                          ),
                          const SizedBox(height: 22),
                          buildField(
                            label: 'Area',
                            hint: 'e.g. South Africa',
                            icon: Icons.location_on_outlined,
                            controller: areaController,
                            type: TextInputType.text,
                          ),
                          buildField(
                            label: 'Crop',
                            hint: 'e.g. Maize',
                            icon: Icons.grass_outlined,
                            controller: itemController,
                            type: TextInputType.text,
                          ),
                          buildField(
                            label: 'Year',
                            hint: 'e.g. 2024',
                            icon: Icons.calendar_today_outlined,
                            controller: yearController,
                            type: TextInputType.number,
                          ),
                          buildField(
                            label: 'Average rainfall (mm/year)',
                            hint: 'e.g. 500',
                            icon: Icons.water_drop_outlined,
                            controller: rainfallController,
                            type: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          buildField(
                            label: 'Pesticides (tonnes)',
                            hint: 'e.g. 12.5',
                            icon: Icons.science_outlined,
                            controller: pesticidesController,
                            type: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          buildField(
                            label: 'Average temperature (°C)',
                            hint: 'e.g. 22.4',
                            icon: Icons.thermostat_outlined,
                            controller: temperatureController,
                            type: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: loading ? null : predict,
                              icon: loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.auto_graph_rounded),
                              label: Text(
                                loading ? 'Calculating yield…' : 'Predict yield',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (result.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _ResultCard(
                      result: result,
                      isSuccess: _hasSuccessfulResult,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F6B41), Color(0xFF4E9A60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332F7D4A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.eco_outlined, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crop Yield Predictor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Make data-informed growing decisions.',
                  style: TextStyle(color: Color(0xFFE6F4E8), fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.isSuccess});

  final String result;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? const Color(0xFF2F7D4A) : const Color(0xFFB54708);
    final background = isSuccess ? const Color(0xFFEAF5EB) : const Color(0xFFFFF3E9);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
