import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/bvg_stop.dart';
import '../../../domain/usecases/get_departures_usecase.dart';
import 'departures_state.dart';

/// Cubit for managing departures functionality
class DeparturesCubit extends Cubit<DeparturesState> {
  DeparturesCubit(this._getDeparturesUseCase) : super(const DeparturesInitial());

  final GetDeparturesUseCase _getDeparturesUseCase;

  /// Load departures for the selected stop
  Future<void> loadDepartures(BvgStop stop) async {
    emit(DeparturesLoading(selectedStop: stop));

    try {
      final departures = await _getDeparturesUseCase(
        stop.id,
        limit: 30,
        duration: 60,
      );

      emit(DeparturesSuccess(
        selectedStop: stop,
        departures: departures,
      ));
    } catch (e) {
      emit(DeparturesError(
        selectedStop: stop,
        message: _getErrorMessage(e),
      ));
    }
  }

  /// Refresh departures for the currently selected stop
  Future<void> refreshDepartures() async {
    final currentState = state;
    if (currentState is DeparturesSuccess) {
      await loadDepartures(currentState.selectedStop);
    } else if (currentState is DeparturesError) {
      await loadDepartures(currentState.selectedStop);
    }
  }

  /// Clear departures and return to initial state
  void clearDepartures() {
    emit(const DeparturesInitial());
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
    } else if (errorString.contains('Stop ID cannot be empty')) {
      return 'Invalid stop selected. Please try again.';
    } else {
      return 'Failed to load departures. Please try again.';
    }
  }
}
