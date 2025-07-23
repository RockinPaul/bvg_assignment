// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bvg_stop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BvgStopModel _$BvgStopModelFromJson(Map<String, dynamic> json) => BvgStopModel(
  id: json['id'] as String,
  name: json['name'] as String,
  location: BvgStopModel._locationFromJson(
    json['location'] as Map<String, dynamic>?,
  ),
  products: BvgStopModel._productsFromJson(
    json['products'] as Map<String, dynamic>?,
  ),
);

Map<String, dynamic> _$BvgStopModelToJson(BvgStopModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': BvgStopModel._locationToJson(instance.location),
      'products': BvgStopModel._productsToJson(instance.products),
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

ProductsModel _$ProductsModelFromJson(Map<String, dynamic> json) =>
    ProductsModel(
      suburban: json['suburban'] as bool? ?? false,
      subway: json['subway'] as bool? ?? false,
      tram: json['tram'] as bool? ?? false,
      bus: json['bus'] as bool? ?? false,
      ferry: json['ferry'] as bool? ?? false,
      express: json['express'] as bool? ?? false,
      regional: json['regional'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductsModelToJson(ProductsModel instance) =>
    <String, dynamic>{
      'suburban': instance.suburban,
      'subway': instance.subway,
      'tram': instance.tram,
      'bus': instance.bus,
      'ferry': instance.ferry,
      'express': instance.express,
      'regional': instance.regional,
    };
