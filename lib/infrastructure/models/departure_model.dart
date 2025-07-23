import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/departure.dart';
import '../../domain/entities/transport_mode.dart';
import 'transport_mode_model.dart';

part 'departure_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DepartureModel {
  const DepartureModel({
    required this.transportMode,
    required this.direction,
    required this.plannedTime,
    this.realTime,
    this.delay,
    this.platform,
    this.cancelled = false,
  });

  @JsonKey(fromJson: _transportModeFromJson, toJson: _transportModeToJson)
  final TransportModeModel transportMode;
  final String direction;
  final DateTime plannedTime;
  final DateTime? realTime;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final Duration? delay;
  final String? platform;
  final bool cancelled;

  factory DepartureModel.fromJson(Map<String, dynamic> json) => 
      _$DepartureModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartureModelToJson(this);

  /// Convert from API response to model
  factory DepartureModel.fromApiResponse(Map<String, dynamic> json) {
    final lineJson = json['line'] as Map<String, dynamic>?;
    final whenJson = json['when'] as String?;
    final plannedWhenJson = json['plannedWhen'] as String?;
    final delayJson = json['delay'] as int?;
    final platformJson = json['platform'] as String?;
    final cancelledJson = json['cancelled'] as bool? ?? false;

    // Parse transport mode
    final transportMode = _parseTransportMode(lineJson);
    
    // Parse times
    final plannedTime = DateTime.parse(plannedWhenJson ?? whenJson!);
    final realTime = whenJson != null ? DateTime.parse(whenJson) : null;
    
    // Parse delay
    Duration? delay;
    if (delayJson != null && delayJson > 0) {
      delay = Duration(seconds: delayJson);
    }

    // Parse direction
    final direction = json['direction'] as String? ?? 
                     lineJson?['name'] as String? ?? 
                     'Unknown destination';

    return DepartureModel(
      transportMode: TransportModeModel.fromEntity(transportMode),
      direction: direction,
      plannedTime: plannedTime,
      realTime: realTime,
      delay: delay,
      platform: platformJson,
      cancelled: cancelledJson,
    );
  }

  /// Parse transport mode from API line data
  static TransportMode _parseTransportMode(Map<String, dynamic>? lineJson) {
    if (lineJson == null) {
      return const TransportMode(
        type: TransportType.bus,
        name: 'Unknown',
        line: 'Unknown',
      );
    }

    final product = lineJson['product'] as String?;
    final name = lineJson['name'] as String? ?? 'Unknown';
    final fahrtNr = lineJson['fahrtNr'] as String?;
    final color = lineJson['color'] as Map<String, dynamic>?;

    TransportType type;
    switch (product?.toLowerCase()) {
      case 'suburban':
        type = TransportType.suburban;
        break;
      case 'subway':
        type = TransportType.subway;
        break;
      case 'tram':
        type = TransportType.tram;
        break;
      case 'bus':
        type = TransportType.bus;
        break;
      case 'ferry':
        type = TransportType.ferry;
        break;
      case 'express':
      case 'national':
      case 'nationalExpress':
        type = TransportType.express;
        break;
      default:
        type = TransportType.bus;
    }

    return TransportMode(
      type: type,
      name: name,
      line: fahrtNr ?? name,
      color: color?['hex'] as String?,
    );
  }

  static TransportModeModel _transportModeFromJson(Map<String, dynamic> json) {
    return TransportModeModel.fromJson(json);
  }

  static Map<String, dynamic> _transportModeToJson(TransportModeModel transportMode) {
    return transportMode.toJson();
  }

  static Duration? _durationFromJson(int? seconds) {
    return seconds != null ? Duration(seconds: seconds) : null;
  }

  static int? _durationToJson(Duration? duration) {
    return duration?.inSeconds;
  }

  /// Convert to domain entity
  Departure toEntity() {
    return Departure(
      transportMode: transportMode.toEntity(),
      direction: direction,
      plannedTime: plannedTime,
      realTime: realTime,
      delay: delay,
      platform: platform,
      cancelled: cancelled,
    );
  }
}
