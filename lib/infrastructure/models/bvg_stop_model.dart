import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/bvg_stop.dart';

part 'bvg_stop_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BvgStopModel {
  const BvgStopModel({
    required this.id,
    required this.name,
    this.location,
    this.products,
  });

  final String id;
  final String name;
  @JsonKey(fromJson: _locationFromJson, toJson: _locationToJson)
  final LocationModel? location;
  @JsonKey(fromJson: _productsFromJson, toJson: _productsToJson)
  final ProductsModel? products;

  factory BvgStopModel.fromJson(Map<String, dynamic> json) => 
      _$BvgStopModelFromJson(json);

  Map<String, dynamic> toJson() => _$BvgStopModelToJson(this);

  static LocationModel? _locationFromJson(Map<String, dynamic>? json) {
    return json != null ? LocationModel.fromJson(json) : null;
  }

  static Map<String, dynamic>? _locationToJson(LocationModel? location) {
    return location?.toJson();
  }

  static ProductsModel? _productsFromJson(Map<String, dynamic>? json) {
    return json != null ? ProductsModel.fromJson(json) : null;
  }

  static Map<String, dynamic>? _productsToJson(ProductsModel? products) {
    return products?.toJson();
  }

  /// Convert from domain entity to model
  factory BvgStopModel.fromEntity(BvgStop entity) {
    LocationModel? locationModel;
    if (entity.location != null) {
      locationModel = LocationModel(
        latitude: entity.location!.latitude,
        longitude: entity.location!.longitude,
      );
    }

    ProductsModel? productsModel;
    if (entity.products != null) {
      productsModel = ProductsModel(
        suburban: entity.products!.suburban,
        subway: entity.products!.subway,
        tram: entity.products!.tram,
        bus: entity.products!.bus,
        ferry: entity.products!.ferry,
        express: entity.products!.express,
        regional: entity.products!.regional,
      );
    }

    return BvgStopModel(
      id: entity.id,
      name: entity.name,
      location: locationModel,
      products: productsModel,
    );
  }

  /// Convert to domain entity
  BvgStop toEntity() {
    return BvgStop(
      id: id,
      name: name,
      location: location?.toEntity(),
      products: products?.toEntity(),
    );
  }
}

@JsonSerializable()
class LocationModel {
  const LocationModel({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  factory LocationModel.fromJson(Map<String, dynamic> json) => 
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  /// Convert to domain entity
  Location toEntity() {
    return Location(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

@JsonSerializable()
class ProductsModel {
  const ProductsModel({
    this.suburban = false,
    this.subway = false,
    this.tram = false,
    this.bus = false,
    this.ferry = false,
    this.express = false,
    this.regional = false,
  });

  final bool suburban;
  final bool subway;
  final bool tram;
  final bool bus;
  final bool ferry;
  final bool express;
  final bool regional;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => 
      _$ProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsModelToJson(this);

  /// Convert to domain entity
  Products toEntity() {
    return Products(
      suburban: suburban,
      subway: subway,
      tram: tram,
      bus: bus,
      ferry: ferry,
      express: express,
      regional: regional,
    );
  }
}
