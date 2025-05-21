// 📄 lib/pages/traffic/logic/chart_logic.dart

class ChartLogic {
  static String generateBarChartUrl({
    required String date,
    required String time,
    required String trafficType,
  }) {
    final safeType = trafficType.replaceAll(' ', '');
    final safeTime = time.replaceAll(":", "-");
    return 'http://localhost:5000/barchart/bar_${date}_${safeTime}_$safeType.html';
  }

  // Add pie chart and line chart logic here later
}
