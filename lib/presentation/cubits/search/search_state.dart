import 'package:equatable/equatable.dart';

import '../../../domain/entities/bvg_stop.dart';

/// Base class for all search states
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no search has been performed
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// State when search is in progress
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// State when search completed successfully
class SearchSuccess extends SearchState {
  const SearchSuccess({
    required this.stops,
    required this.query,
  });

  final List<BvgStop> stops;
  final String query;

  @override
  List<Object?> get props => [stops, query];
}

/// State when search failed with error
class SearchError extends SearchState {
  const SearchError({
    required this.message,
    required this.query,
  });

  final String message;
  final String query;

  @override
  List<Object?> get props => [message, query];
}

/// State when search is cleared
class SearchCleared extends SearchState {
  const SearchCleared();
}
