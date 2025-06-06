import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> downloadReport({
  required BuildContext context,
  required String? date,
  required String? time,
  required String? trafficType,
}) async {
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
          backgroundColor: Colors.green,
          content: Text('Report successfully generated and saved.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 600),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Failed to generate report: ${response.body}'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 600),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Error: $e'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 600),
      ),
    );
  }
}
