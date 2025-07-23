import 'package:equatable/equatable.dart';

/// Domain entity representing a BVG stop/station
class BvgStop extends Equatable {
  const BvgStop({
    required this.id,
    required this.name,
    this.location,
    this.products,
  });

  final String id; // Unique identifier for the stop
  final String name; // Display name of the stop
  final Location? location; // Geographic coordinates
  final Products? products; // Available transport modes at this stop

  @override
  List<Object?> get props => [id, name, location, products];

  @override
  String toString() => 'BvgStop(id: $id, name: $name, location: $location, products: $products)';
}

/// Geographic location of a stop
class Location extends Equatable {
  const Location({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Products/transport modes available at a stop
class Products extends Equatable {
  const Products({
    this.suburban = false,
    this.subway = false,
    this.tram = false,
    this.bus = false,
    this.ferry = false,
    this.express = false,
    this.regional = false,
  });

  final bool suburban; // S-Bahn
  final bool subway; // U-Bahn
  final bool tram;
  final bool bus;
  final bool ferry;
  final bool express; // ICE/IC
  final bool regional; // RE/RB

  @override
  List<Object?> get props => [suburban, subway, tram, bus, ferry, express, regional];
}
