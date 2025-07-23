import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../domain/repositories/bvg_repository.dart';
import '../../domain/usecases/get_departures_usecase.dart';
import '../../domain/usecases/search_stops_usecase.dart';
import '../../infrastructure/datasources/bvg_remote_datasource.dart';
import '../../infrastructure/repositories/bvg_repository_impl.dart';
import '../../presentation/cubits/departures/departures_cubit.dart';
import '../../presentation/cubits/search/search_cubit.dart';

final GetIt sl = GetIt.instance;

/// Initialize all dependencies for dependency injection
Future<void> initializeDependencies() async {
  // External dependencies
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data sources
  sl.registerLazySingleton<BvgRemoteDataSource>(
    () => BvgRemoteDataSource(sl<http.Client>()),
  );

  // Repositories
  sl.registerLazySingleton<BvgRepository>(
    () => BvgRepositoryImpl(sl<BvgRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<SearchStopsUseCase>(
    () => SearchStopsUseCase(sl<BvgRepository>()),
  );
  
  sl.registerLazySingleton<GetDeparturesUseCase>(
    () => GetDeparturesUseCase(sl<BvgRepository>()),
  );

  // Cubits (Factory registration for fresh instances)
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl<SearchStopsUseCase>()),
  );
  
  sl.registerFactory<DeparturesCubit>(
    () => DeparturesCubit(sl<GetDeparturesUseCase>()),
  );
}

/// Clean up resources when app is disposed
void disposeDependencies() {
  sl.reset();
}
