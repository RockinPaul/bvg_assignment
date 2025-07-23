import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/design_system.dart';
import 'core/di/service_locator.dart';
import 'core/routes/app_router.dart';
import 'presentation/cubits/departures/departures_cubit.dart';
import 'presentation/cubits/search/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initializeDependencies();
  
  runApp(const BvgApp());
}

class BvgApp extends StatelessWidget {
  const BvgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>(
          create: (context) => sl<SearchCubit>(),
        ),
        BlocProvider<DeparturesCubit>(
          create: (context) => sl<DeparturesCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'BVG Departures',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
