import 'package:go_router/go_router.dart';

import '../../domain/entities/bvg_stop.dart';
import '../../presentation/pages/departures_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/search_page.dart';

/// Application router configuration using go_router
class AppRouter {
  static const String homePath = '/';
  static const String searchPath = '/search';
  static const String departuresPath = '/departures';

  static final GoRouter router = GoRouter(
    initialLocation: homePath,
    routes: [
      GoRoute(
        path: homePath,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: searchPath,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: departuresPath,
        name: 'departures',
        builder: (context, state) {
          final stop = state.extra as BvgStop;
          return DeparturesPage(stop: stop);
        },
      ),
    ],
  );
}
