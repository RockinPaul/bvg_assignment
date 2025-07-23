import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/bvg_stop_model.dart';
import '../models/departure_model.dart';

/// Exception thrown when API request fails
class ApiException implements Exception {
  const ApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Remote data source for BVG API
class BvgRemoteDataSource {
  const BvgRemoteDataSource(this._httpClient);

  final http.Client _httpClient;

  /// Search for stops using the BVG API locations endpoint
  Future<List<BvgStopModel>> searchStops(String query) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.locationsEndpoint).replace(
        queryParameters: {
          ApiConstants.queryParam: query,
          ApiConstants.resultsParam: ApiConstants.defaultSearchLimit.toString(),
          ApiConstants.fuzzyParam: 'true',
          ApiConstants.stopsEndpoint.substring(1): 'true', // Remove leading slash
          ApiConstants.addressesParam: 'false',
          ApiConstants.poiParam: 'false',
        },
      );

      final response = await _httpClient.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'BVG Flutter App',
        },
      ).timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData is List) {
          return jsonData
              .map((item) => _parseStopFromApi(item as Map<String, dynamic>))
              .where((stop) => stop != null)
              .cast<BvgStopModel>()
              .toList();
        } else if (jsonData is Map<String, dynamic> && jsonData.containsKey('features')) {
          // Handle GeoJSON response format
          final features = jsonData['features'] as List<dynamic>? ?? [];
          return features
              .map((feature) => _parseStopFromGeoJson(feature as Map<String, dynamic>))
              .where((stop) => stop != null)
              .cast<BvgStopModel>()
              .toList();
        }
        
        return [];
      } else {
        throw ApiException(
          'Failed to search stops: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw const ApiException('No internet connection');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Get departures for a specific stop
  Future<List<DepartureModel>> getDepartures(
    String stopId, {
    int limit = ApiConstants.defaultDeparturesLimit,
    int duration = ApiConstants.defaultDurationMinutes,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.stopsEndpoint}/$stopId${ApiConstants.departuresPath}',
      ).replace(
        queryParameters: {
          ApiConstants.limitParam: limit.toString(),
          ApiConstants.durationParam: duration.toString(),
        },
      );

      final response = await _httpClient.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'BVG Flutter App',
        },
      ).timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('departures')) {
          final departures = jsonData['departures'] as List<dynamic>? ?? [];
          return departures
              .map((item) => DepartureModel.fromApiResponse(item as Map<String, dynamic>))
              .toList();
        } else if (jsonData is List) {
          return jsonData
              .map((item) => DepartureModel.fromApiResponse(item as Map<String, dynamic>))
              .toList();
        }
        
        return [];
      } else {
        throw ApiException(
          'Failed to get departures: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw const ApiException('No internet connection');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Parse stop data from API response
  BvgStopModel? _parseStopFromApi(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String?;
      final name = json['name'] as String?;
      
      if (id == null || name == null) return null;

      // Parse location if available
      LocationModel? location;
      if (json.containsKey('location')) {
        final locationJson = json['location'] as Map<String, dynamic>?;
        final latitude = locationJson?['latitude'] as double?;
        final longitude = locationJson?['longitude'] as double?;
        
        if (latitude != null && longitude != null) {
          location = LocationModel(latitude: latitude, longitude: longitude);
        }
      }

      // Parse products if available
      ProductsModel? products;
      if (json.containsKey('products')) {
        final productsJson = json['products'] as Map<String, dynamic>?;
        if (productsJson != null) {
          products = ProductsModel(
            suburban: productsJson['suburban'] as bool? ?? false,
            subway: productsJson['subway'] as bool? ?? false,
            tram: productsJson['tram'] as bool? ?? false,
            bus: productsJson['bus'] as bool? ?? false,
            ferry: productsJson['ferry'] as bool? ?? false,
            express: productsJson['express'] as bool? ?? false,
            regional: productsJson['regional'] as bool? ?? false,
          );
        }
      }

      return BvgStopModel(
        id: id,
        name: name,
        location: location,
        products: products,
      );
    } catch (e) {
      return null;
    }
  }

  /// Parse stop data from GeoJSON feature
  BvgStopModel? _parseStopFromGeoJson(Map<String, dynamic> feature) {
    try {
      final properties = feature['properties'] as Map<String, dynamic>?;
      final geometry = feature['geometry'] as Map<String, dynamic>?;
      
      if (properties == null) return null;
      
      final id = properties['id'] as String?;
      final name = properties['name'] as String?;
      
      if (id == null || name == null) return null;

      // Parse coordinates from geometry
      LocationModel? location;
      if (geometry != null && geometry['type'] == 'Point') {
        final coordinates = geometry['coordinates'] as List<dynamic>?;
        if (coordinates != null && coordinates.length >= 2) {
          final longitude = (coordinates[0] as num?)?.toDouble();
          final latitude = (coordinates[1] as num?)?.toDouble();
          
          if (latitude != null && longitude != null) {
            location = LocationModel(latitude: latitude, longitude: longitude);
          }
        }
      }

      return BvgStopModel(
        id: id,
        name: name,
        location: location,
      );
    } catch (e) {
      return null;
    }
  }
}
