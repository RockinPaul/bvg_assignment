import '../entities/bvg_stop.dart';
import '../entities/departure.dart';

/// Abstract repository interface for BVG data access
/// This defines the contract that infrastructure layer must implement
abstract class BvgRepository {
  /// Search for BVG stops/stations by query string
  /// Returns a list of matching stops for autocomplete functionality
  Future<List<BvgStop>> searchStops(String query);

  /// Get departures for a specific stop
  /// [stopId] - The unique identifier of the stop
  /// [limit] - Maximum number of departures to return (default: 30)
  /// [duration] - Time window in minutes to look ahead (default: 60)
  Future<List<Departure>> getDepartures(
    String stopId, {
    int limit = 30,
    int duration = 60,
  });
}
