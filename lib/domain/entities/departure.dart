import 'package:equatable/equatable.dart';

import 'transport_mode.dart';

/// Domain entity representing a departure from a BVG stop
class Departure extends Equatable {
  const Departure({
    required this.transportMode,
    required this.direction,
    required this.plannedTime,
    this.realTime,
    this.delay,
    this.platform,
    this.cancelled = false,
  });

  final TransportMode transportMode; // Transport information (U7, M4, etc.)
  final String direction; // Destination/direction of the transport
  final DateTime plannedTime; // Scheduled departure time
  final DateTime? realTime; // Actual departure time (if available)
  final Duration? delay; // Delay duration
  final String? platform; // Platform or stop position
  final bool cancelled; // Whether the departure is cancelled

  /// Returns the effective departure time (real time if available, otherwise planned)
  DateTime get effectiveTime => realTime ?? plannedTime;

  /// Returns true if the departure is delayed
  bool get isDelayed => delay != null && delay!.inMinutes > 0;

  /// Returns true if the departure is on time
  bool get isOnTime => !isDelayed && !cancelled;

  /// Returns formatted delay string (e.g., "+3 min")
  String get delayText {
    if (delay == null || delay!.inMinutes <= 0) return '';
    return '+${delay!.inMinutes} min';
  }

  /// Returns departure status text
  String get statusText {
    if (cancelled) return 'cancelled';
    if (isDelayed) return 'delayed';
    return 'on-time';
  }

  @override
  List<Object?> get props => [
        transportMode,
        direction,
        plannedTime,
        realTime,
        delay,
        platform,
        cancelled,
      ];

  @override
  String toString() => 'Departure('
      'transportMode: $transportMode, '
      'direction: $direction, '
      'plannedTime: $plannedTime, '
      'realTime: $realTime, '
      'delay: $delay, '
      'platform: $platform, '
      'cancelled: $cancelled)';
}
