// ====================================================
// Traffic Logic (API Calls)
// ----------------------------------------------------
// - Sends POST request to generate heatmap HTML
// - Fetches snapshot data for all locations
// - Fetches summary stats for charts (bar, pie, etc.)
// ====================================================

import 'dart:convert';
import 'package:http/http.dart' as http;

class TrafficLogic {
  static const String baseUrl = 'http://localhost:5000';

  /// Generate heatmap and return the full URL to the HTML
  static Future<String> generateHeatmap(
      String date, String time, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/generate_heatmap'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': date,
        'time': time,
        'traffic_type': type,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      final result = jsonDecode(response.body);
      return result['heatmap_url'];
    } else {
      throw Exception('Heatmap generation failed (${response.statusCode})');
    }
  }

  /// Fetch location snapshot from /api/location_snapshot
  static Future<List<dynamic>> fetchSnapshot(
      String date, String time, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/location_snapshot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': date,
        'time': time,
        'traffic_type': type,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Snapshot fetch failed (${response.statusCode})');
    }
  }

  /// Fetch summary statistics from /api/summary_stats
  static Future<Map<String, dynamic>> fetchSummaryStats(
      String date, String time, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/summary_stats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': date,
        'time': time,
        'traffic_type': type,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Summary stats fetch failed (${response.statusCode})');
    }
  }
}
