// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_mode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransportModeModel _$TransportModeModelFromJson(Map<String, dynamic> json) =>
    TransportModeModel(
      type: TransportModeModel._transportTypeFromJson(json['type'] as String),
      name: json['name'] as String,
      line: json['line'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$TransportModeModelToJson(TransportModeModel instance) =>
    <String, dynamic>{
      'type': TransportModeModel._transportTypeToJson(instance.type),
      'name': instance.name,
      'line': instance.line,
      'color': instance.color,
    };
