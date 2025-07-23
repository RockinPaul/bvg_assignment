import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/transport_mode.dart';

part 'transport_mode_model.g.dart';

@JsonSerializable()
class TransportModeModel {
  const TransportModeModel({
    required this.type,
    required this.name,
    required this.line,
    this.color,
  });

  @JsonKey(fromJson: _transportTypeFromJson, toJson: _transportTypeToJson)
  final TransportType type;
  final String name;
  final String line;
  final String? color;

  factory TransportModeModel.fromJson(Map<String, dynamic> json) => 
      _$TransportModeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransportModeModelToJson(this);

  static TransportType _transportTypeFromJson(String type) {
    switch (type.toLowerCase()) {
      case 'subway':
        return TransportType.subway;
      case 'suburban':
        return TransportType.suburban;
      case 'tram':
        return TransportType.tram;
      case 'bus':
        return TransportType.bus;
      case 'ferry':
        return TransportType.ferry;
      case 'express':
      case 'national':
      case 'nationalExpress':
        return TransportType.express;
      default:
        return TransportType.bus;
    }
  }

  static String _transportTypeToJson(TransportType type) {
    switch (type) {
      case TransportType.subway:
        return 'subway';
      case TransportType.suburban:
        return 'suburban';
      case TransportType.tram:
        return 'tram';
      case TransportType.bus:
        return 'bus';
      case TransportType.ferry:
        return 'ferry';
      case TransportType.express:
        return 'express';
    }
  }

  /// Convert from domain entity to model
  factory TransportModeModel.fromEntity(TransportMode entity) {
    return TransportModeModel(
      type: entity.type,
      name: entity.name,
      line: entity.line,
      color: entity.color,
    );
  }

  /// Convert to domain entity
  TransportMode toEntity() {
    return TransportMode(
      type: type,
      name: name,
      line: line,
      color: color,
    );
  }
}
