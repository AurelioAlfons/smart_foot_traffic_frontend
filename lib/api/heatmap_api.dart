// ====================================================
// Preload Heatmap Request
// ----------------------------------------------------
// - Sends POST request to preload heatmap in backend
// - Uses traffic type, date, time, and season as input
// - Prints result status to console
// ====================================================

// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> preloadHeatmap({
  required String trafficType,
  required String date,
  String? time,
  String? season,
}) async {
  const String baseUrl =
      "https://smart-foot-traffic-backend.onrender.com"; // or http://localhost:5000 for local
  final url = Uri.parse("$baseUrl/api/preload_heatmap");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "traffic_type": trafficType,
      "date": date,
      "time": time,
      "season": season,
    }),
  );

  if (response.statusCode == 202) {
    print("✅ Preload started successfully");
  } else {
    print("⚠️ Preload failed: ${response.body}");
  }
}
