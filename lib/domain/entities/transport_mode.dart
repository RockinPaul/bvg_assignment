import 'package:equatable/equatable.dart';

/// Represents different transport modes in BVG system
enum TransportType {
  subway, // U-Bahn
  suburban, // S-Bahn
  bus,
  tram,
  ferry,
  express, // RE/RB
}

/// Domain entity representing a transport mode with its visual information
class TransportMode extends Equatable {
  const TransportMode({
    required this.type,
    required this.name,
    required this.line,
    this.color,
  });

  final TransportType type;
  final String name; // e.g., "U7", "M4", "RE1"
  final String line; // Line identifier
  final String? color; // Hex color for the transport line

  @override
  List<Object?> get props => [type, name, line, color];

  @override
  String toString() => 'TransportMode(type: $type, name: $name, line: $line, color: $color)';
}
