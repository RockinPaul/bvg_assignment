import '../entities/bvg_stop.dart';
import '../repositories/bvg_repository.dart';

/// Use case for searching BVG stops with autocomplete functionality
class SearchStopsUseCase {
  const SearchStopsUseCase(this._repository);

  final BvgRepository _repository;

  /// Execute the search stops use case
  /// [query] - Search query string
  /// Returns a list of matching BVG stops
  Future<List<BvgStop>> call(String query) async {
    // Validate input
    if (query.trim().isEmpty) {
      return [];
    }

    // Minimum query length for search
    if (query.trim().length < 2) {
      return [];
    }

    try {
      return await _repository.searchStops(query.trim());
    } catch (e) {
      // Re-throw for presentation layer to handle
      rethrow;
    }
  }
}
