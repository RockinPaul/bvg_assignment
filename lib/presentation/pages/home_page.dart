import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/design_system.dart';
import '../../domain/entities/bvg_stop.dart';
import '../cubits/search/search_cubit.dart';
import '../cubits/search/search_state.dart';
import '../widgets/search_field_widget.dart';
import '../widgets/stops_suggestions_widget.dart';

/// Main home page implementing the BVG departures search interface
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  void _onStopSelected(BvgStop stop) {
    // Clear search field and unfocus
    _searchController.clear();
    _searchFocusNode.unfocus();
    
    // Clear search results
    context.read<SearchCubit>().clearSearch();
    
    // Navigate to departures page
    context.pushNamed(
      'departures',
      extra: stop,
    );
  }

  void _onSearchCleared() {
    _searchController.clear();
    context.read<SearchCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top app bar with search
            Container(
              height: DesignSystem.topAppBarHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacing20,
                vertical: DesignSystem.spacing8,
              ),
              decoration: const BoxDecoration(
                color: DesignSystem.backgroundPrimary,
                border: Border(
                  bottom: BorderSide(
                    color: DesignSystem.grey100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Status bar time display (static for demo)
                  Text(
                    '9:41',
                    style: DesignSystem.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            
            // Search container
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacing20),
              child: SearchFieldWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (query) {
                  context.read<SearchCubit>().searchStops(query);
                },
                onClear: _onSearchCleared,
              ),
            ),
            
            // Main content area
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, searchState) {
                  if (searchState is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (searchState is SearchSuccess && searchState.stops.isNotEmpty) {
                    // Show search results
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
