/// API constants for BVG transport REST API
class Constants {
  static const String baseUrl = 'https://v6.bvg.transport.rest';
  static const String locationsEndpoint = '/locations';
  static const String stopsEndpoint = '/stops';
  static const String departuresPath = '/departures';

  // Request timeouts
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration connectionTimeout = Duration(seconds: 5);

  // Query parameters
  static const String queryParam = 'query';
  static const String limitParam = 'limit';
  static const String durationParam = 'duration';
  static const String resultsParam = 'results';
  static const String fuzzyParam = 'fuzzy';
  static const String addressesParam = 'addresses';
  static const String poiParam = 'poi';

  // Default values
  static const int defaultSearchLimit = 10;
  static const int defaultDeparturesLimit = 30;
  static const int defaultDurationMinutes = 60;
}