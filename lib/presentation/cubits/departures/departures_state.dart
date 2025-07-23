import 'package:equatable/equatable.dart';

import '../../../domain/entities/bvg_stop.dart';
import '../../../domain/entities/departure.dart';

/// Base class for all departures states
abstract class DeparturesState extends Equatable {
  const DeparturesState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no stop is selected
class DeparturesInitial extends DeparturesState {
  const DeparturesInitial();
}

/// State when departures are being loaded
class DeparturesLoading extends DeparturesState {
  const DeparturesLoading({
    required this.selectedStop,
  });

  final BvgStop selectedStop;

  @override
  List<Object?> get props => [selectedStop];
}

/// State when departures loaded successfully
class DeparturesSuccess extends DeparturesState {
  const DeparturesSuccess({
    required this.selectedStop,
    required this.departures,
  });

  final BvgStop selectedStop;
  final List<Departure> departures;

  @override
  List<Object?> get props => [selectedStop, departures];
}

/// State when departures loading failed
class DeparturesError extends DeparturesState {
  const DeparturesError({
    required this.selectedStop,
    required this.message,
  });

  final BvgStop selectedStop;
  final String message;

  @override
  List<Object?> get props => [selectedStop, message];
}
