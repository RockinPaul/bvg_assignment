import '../entities/departure.dart';
import '../repositories/bvg_repository.dart';

/// Use case for retrieving departures from a specific BVG stop
class GetDeparturesUseCase {
  const GetDeparturesUseCase(this._repository);

  final BvgRepository _repository;

  /// Execute the get departures use case
  /// [stopId] - The unique identifier of the stop
  /// [limit] - Maximum number of departures to return (default: 30)
  /// [duration] - Time window in minutes to look ahead (default: 60)
  /// Returns a chronologically sorted list of departures
  Future<List<Departure>> call(
    String stopId, {
    int limit = 30,
    int duration = 60,
  }) async {
    // Validate input
    if (stopId.trim().isEmpty) {
      throw ArgumentError('Stop ID cannot be empty');
    }

    if (limit <= 0) {
      throw ArgumentError('Limit must be greater than 0');
    }

    if (duration <= 0) {
      throw ArgumentError('Duration must be greater than 0');
    }

    try {
      final departures = await _repository.getDepartures(
        stopId.trim(),
        limit: limit,
        duration: duration,
      );

      // Sort departures chronologically by effective time
      departures.sort((a, b) => a.effectiveTime.compareTo(b.effectiveTime));

      return departures;
    } catch (e) {
      // Re-throw for presentation layer to handle
      rethrow;
    }
  }
}
