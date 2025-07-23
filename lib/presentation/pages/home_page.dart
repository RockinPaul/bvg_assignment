import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/design_system.dart';
import '../../domain/entities/bvg_stop.dart';
import '../cubits/search/search_cubit.dart';
import '../cubits/search/search_state.dart';
import '../widgets/stops_suggestions_widget.dart';

/// Main home page implementing the BVG departures search interface
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onStopSelected(BvgStop stop) {
    // Clear search results
    context.read<SearchCubit>().clearSearch();

    // Navigate to departures page
    context.pushNamed('departures', extra: stop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacing20),
              child: GestureDetector(
                onTap: () {
                  context.pushNamed('search');
                },
                child: Container(
                  height: DesignSystem.searchBarHeight,
                  decoration: BoxDecoration(
                    color: DesignSystem.backgroundPrimary,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: DesignSystem.grey500,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignSystem.spacing16,
                        ),
                        child: Icon(
                          Icons.search,
                          color: DesignSystem.grey500,
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Search for station',
                          style: DesignSystem.bodyLarge.copyWith(
                            color: DesignSystem.grey500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(color: DesignSystem.grey500, height: 1.0),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, searchState) {
                  if (searchState is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (searchState is SearchSuccess &&
                      searchState.stops.isNotEmpty) {
                    return StopsSuggestionsWidget(
                      stops: searchState.stops,
                      onStopSelected: _onStopSelected,
                    );
                  }

                  if (searchState is SearchError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(DesignSystem.spacing24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: DesignSystem.red600,
                            ),
                            const SizedBox(height: DesignSystem.spacing16),
                            Text(
                              searchState.message,
                              style: DesignSystem.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Default state - show welcome message
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(DesignSystem.spacing24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: DesignSystem.grey500,
                          ),
                          const SizedBox(height: DesignSystem.spacing24),
                          Text(
                            'Find the best\npublic transport\nconnections',
                            style: DesignSystem.headlineLarge.copyWith(
                              color: DesignSystem.grey600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: DesignSystem.spacing16),
                          Text(
                            'Search for a BVG station to see upcoming departures',
                            style: DesignSystem.bodyLarge.copyWith(
                              color: DesignSystem.grey600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
