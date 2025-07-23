import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/search_stops_usecase.dart';
import 'search_state.dart';

/// Cubit for managing search functionality
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._searchStopsUseCase) : super(const SearchInitial());

  final SearchStopsUseCase _searchStopsUseCase;
  Timer? _debounceTimer;

  /// Search for stops with debouncing to avoid excessive API calls
  void searchStops(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // If query is empty, clear search
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    // If query is too short, clear search
    if (query.trim().length < 2) {
      emit(const SearchInitial());
      return;
    }

    // Start debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query.trim());
    });
  }

  /// Perform the actual search
  Future<void> _performSearch(String query) async {
    emit(const SearchLoading());

    try {
      final stops = await _searchStopsUseCase(query);
      emit(SearchSuccess(stops: stops, query: query));
    } catch (e) {
      emit(SearchError(
        message: _getErrorMessage(e),
        query: query,
      ));
    }
  }

  /// Clear current search results
  void clearSearch() {
    _debounceTimer?.cancel();
    emit(const SearchCleared());
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('No internet connection')) {
      return 'No internet connection. Please check your network.';
    } else if (errorString.contains('Network error')) {
      return 'Network error. Please try again.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
