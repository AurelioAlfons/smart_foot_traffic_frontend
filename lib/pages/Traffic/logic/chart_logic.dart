// ====================================================
// Chart Logic Generator - Local/Cloud Toggle
// ----------------------------------------------------
// - Builds safe bar chart URL using date, time, and type
// - Comment/uncomment the baseUrl line below to switch env
// ====================================================

class ChartLogic {
  // BASE URL SETUP:

  // ← LOCAL (for dev)
  // static const String baseUrl = 'http://localhost:5000';

  // ← CLOUD (Render)
  static const String baseUrl =
      'https://smart-foot-traffic-backend.onrender.com';

  static String generateBarChartUrl({
    required String date,
    required String time,
    required String trafficType,
  }) {
    final safeType = trafficType.replaceAll(' ', '');
    final safeTime = time.replaceAll(":", "-");
    return '$baseUrl/barchart/bar_${date}_${safeTime}_$safeType.html';
  }

  // Future: Add pie chart and line chart logic here
}
