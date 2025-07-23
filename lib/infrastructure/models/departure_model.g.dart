// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departure_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartureModel _$DepartureModelFromJson(Map<String, dynamic> json) =>
    DepartureModel(
      transportMode: DepartureModel._transportModeFromJson(
        json['transportMode'] as Map<String, dynamic>,
      ),
      direction: json['direction'] as String,
      plannedTime: DateTime.parse(json['plannedTime'] as String),
      realTime:
          json['realTime'] == null
              ? null
              : DateTime.parse(json['realTime'] as String),
      delay: DepartureModel._durationFromJson((json['delay'] as num?)?.toInt()),
      platform: json['platform'] as String?,
      cancelled: json['cancelled'] as bool? ?? false,
    );

Map<String, dynamic> _$DepartureModelToJson(
  DepartureModel instance,
) => <String, dynamic>{
  'transportMode': DepartureModel._transportModeToJson(instance.transportMode),
  'direction': instance.direction,
  'plannedTime': instance.plannedTime.toIso8601String(),
  'realTime': instance.realTime?.toIso8601String(),
  'delay': DepartureModel._durationToJson(instance.delay),
  'platform': instance.platform,
  'cancelled': instance.cancelled,
};
