import '../../domain/entities/bvg_stop.dart';
import '../../domain/entities/departure.dart';
import '../../domain/repositories/bvg_repository.dart';
import '../datasources/bvg_remote_datasource.dart';

/// Concrete implementation of BvgRepository
class BvgRepositoryImpl implements BvgRepository {
  const BvgRepositoryImpl(this._remoteDataSource);

  final BvgRemoteDataSource _remoteDataSource;

  @override
  Future<List<BvgStop>> searchStops(String query) async {
    try {
      final stopModels = await _remoteDataSource.searchStops(query);
      return stopModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Re-throw for use cases to handle
      rethrow;
    }
  }

  @override
  Future<List<Departure>> getDepartures(
    String stopId, {
    int limit = 30,
    int duration = 60,
  }) async {
    try {
      final departureModels = await _remoteDataSource.getDepartures(
        stopId,
        limit: limit,
        duration: duration,
      );
      return departureModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Re-throw for use cases to handle
      rethrow;
    }
  }
}
