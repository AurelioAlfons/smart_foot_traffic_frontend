// ====================================================
// Chart Logic Generator
// ----------------------------------------------------
// - Builds safe bar chart URL using date, time, and type
// - Removes spaces/colons for valid filenames
// - Placeholder for future pie/line chart logic
// ====================================================

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
