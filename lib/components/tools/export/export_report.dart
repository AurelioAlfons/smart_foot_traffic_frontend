import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

Future<void> downloadReport({
  required BuildContext context,
  required String? date,
  required String? time,
  required String? trafficType,
}) async {
  // Validation
  if (date == null || time == null || trafficType == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select Date, Time, and Traffic Type first.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 600),
      ),
    );
    return;
  }

  final uri = Uri.parse(
    'http://localhost:5000/api/download_report?date=$date&time=$time&type=${Uri.encodeComponent(trafficType)}',
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report successfully generated and saved.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 600),
        ),
      );

      // ✅ Open report in new tab using modern `web` package
      final reportUrl = 'http://localhost:5000/downloads/report_$date.html';
      web.window.open(reportUrl, '_blank');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate report: ${response.body}'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 600),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 600),
      ),
    );
  }
}
