// constants.dart
// =======================================
// - Central config for API base URL and endpoints
// - Dynamic bar chart URL generator
// - Used across logic files for clean access
// =======================================

class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );

  // API endpoints
  static String get heatmapEndpoint => '$apiBaseUrl/api/generate_heatmap';
  static String get snapshotEndpoint => '$apiBaseUrl/api/location_snapshot';
  static String get summaryStatsEndpoint => '$apiBaseUrl/api/summary_stats';

  // Default heatmap map URL
  static String get defaultHeatmapUrl =>
      '$apiBaseUrl/heatmaps/default_map.html';

  // Bar Chart URL builder
  static String generateBarChartUrl(
      String date, String time, String trafficType) {
    final safeType = trafficType.replaceAll(' ', '');
    final safeTime = time.replaceAll(':', '-');
    return '$apiBaseUrl/barchart/bar_${date}_${safeTime}_$safeType.html';
  }
}
