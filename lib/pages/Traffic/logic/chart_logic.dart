// ====================================================
// Chart Logic Generator - Local/Cloud Toggle
// ----------------------------------------------------
// - Builds safe bar, line, pie, forecast chart URLs
// - Comment/uncomment the baseUrl line below to switch env
// ====================================================

class ChartLogic {
  // BASE URL SETUP:

  // ← LOCAL (for dev)
  static const String baseUrl = 'http://localhost:5000';

  // ← CLOUD (Render)
  // static const String baseUrl =
  //     'https://smart-foot-traffic-backend.onrender.com';

  static String generateBarChartUrl({
    required String date,
    required String time,
    required String trafficType,
  }) {
    final safeType = trafficType.replaceAll(' ', '');
    final safeTime = time.replaceAll(":", "-");
    return '$baseUrl/barchart/bar_${date}_${safeTime}_$safeType.html';
  }

  static String generateLineChartUrl({
    required String date,
    required String trafficType,
  }) {
    final safeType = trafficType.replaceAll(' ', '');
    return '$baseUrl/linecharts/line_${date}_$safeType.html';
  }

  static String generatePieChartUrl({
    required String date,
  }) {
    return '$baseUrl/piecharts/pie_dashboard_$date.html';
  }

  static String generateForecastChartUrl({
    required String trafficType,
  }) {
    final safeType = trafficType.replaceAll(' ', '_').toLowerCase();
    return '$baseUrl/forecast/forecast_chart_$safeType.html';
  }
}
