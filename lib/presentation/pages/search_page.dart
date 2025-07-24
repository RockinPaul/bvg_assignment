import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/design_system.dart';
import '../../domain/entities/bvg_stop.dart';
import '../cubits/search/search_cubit.dart';
import '../cubits/search/search_state.dart';
import '../widgets/stops_suggestions_widget.dart';

/// Dedicated search page for station search functionality
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onStopSelected(BvgStop stop) {
    // Clear search field and unfocus
    _searchController.clear();
    _searchFocusNode.unfocus();

    // Clear search results
    context.read<SearchCubit>().clearSearch();

    // Navigate to departures page
    context.pushNamed('departures', extra: stop);
  }

  void _onSearchCleared() {
    _searchController.clear();
    context.read<SearchCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: DesignSystem.backgroundPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DesignSystem.primaryText),
          onPressed: () {
            context.read<SearchCubit>().clearSearch();
            context.pop();
          },
        ),
        title: Container(
          height: 36,
          margin: const EdgeInsets.only(right: DesignSystem.spacing8),
          decoration: BoxDecoration(
            color: DesignSystem.grey100,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (query) {
              context.read<SearchCubit>().searchStops(query);
            },
            style: DesignSystem.bodyLarge.copyWith(
              fontSize: 17,
            ),
            decoration: InputDecoration(
              filled: false,
              hintText: 'Search for station',
              hintStyle: DesignSystem.bodyLarge.copyWith(
                color: DesignSystem.grey500,
                fontSize: 17,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 8, right: 4),
                child: Icon(
                  Icons.search,
                  color: DesignSystem.grey500,
                  size: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 34,
                minHeight: 22,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _onSearchCleared,
                      child: const Icon(
                        Icons.clear,
                        color: DesignSystem.grey500,
                        size: 20,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacing8,
                vertical: DesignSystem.spacing8,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<SearchCubit>().clearSearch();
              context.pop();
            },
            child: Text(
              'Cancel',
              style: DesignSystem.bodyLarge.copyWith(
                color: DesignSystem.bluePrimary600,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: DesignSystem.grey500,
            height: 1.0,
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, searchState) {
          if (searchState is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: DesignSystem.bluePrimary600,
              ),
            );
          }

          if (searchState is SearchSuccess && searchState.stops.isNotEmpty) {
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

          // Default state - empty search
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
