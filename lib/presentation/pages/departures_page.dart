import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/design_system.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/bvg_stop.dart';
import '../cubits/departures/departures_cubit.dart';
import '../cubits/departures/departures_state.dart';
import '../widgets/departures_list_widget.dart';

/// Page displaying departures for a selected BVG stop
class DeparturesPage extends StatelessWidget {
  const DeparturesPage({super.key, required this.stop});

  final BvgStop stop;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeparturesCubit>()..loadDepartures(stop),
      child: Scaffold(
        backgroundColor: DesignSystem.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: DesignSystem.backgroundPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: DesignSystem.primaryText),
              onPressed: () => context.pop(),
            ),
          ],
          automaticallyImplyLeading: false,
          title: Text(stop.name, style: DesignSystem.titleLarge),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: DesignSystem.grey600,
              height: 1.0,
            ),
          ),
        ),
        body: BlocBuilder<DeparturesCubit, DeparturesState>(
          builder: (context, state) {
            if (state is DeparturesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: DesignSystem.bluePrimary600,
                ),
              );
            }

            if (state is DeparturesError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(DesignSystem.spacing24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: DesignSystem.red600,
                      ),
                      const SizedBox(height: DesignSystem.spacing24),
                      Text(
                        'Error loading departures',
                        style: DesignSystem.titleLarge.copyWith(
                          color: DesignSystem.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignSystem.spacing8),
                      Text(
                        state.message,
                        style: DesignSystem.bodyLarge.copyWith(
                          color: DesignSystem.grey600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignSystem.spacing24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DeparturesCubit>().loadDepartures(stop);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignSystem.bluePrimary600,
                          foregroundColor: DesignSystem.backgroundPrimary,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is DeparturesSuccess) {
              return DeparturesListWidget(
                selectedStop: stop,
                departures: state.departures,
                onRefresh: () {
                  context.read<DeparturesCubit>().loadDepartures(stop);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
