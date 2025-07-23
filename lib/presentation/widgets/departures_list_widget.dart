import 'package:flutter/material.dart';

import '../../core/constants/design_system.dart';
import '../../domain/entities/bvg_stop.dart';
import '../../domain/entities/departure.dart';
import '../../domain/entities/transport_mode.dart';

/// Widget displaying departures list for a selected stop
class DeparturesListWidget extends StatelessWidget {
  const DeparturesListWidget({
    super.key,
    required this.selectedStop,
    required this.departures,
    required this.onRefresh,
  });

  final BvgStop selectedStop;
  final List<Departure> departures;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: Column(
          children: [
            // Departures list
            Expanded(
              child:
                  departures.isEmpty
                      ? _EmptyDeparturesWidget()
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignSystem.spacing8,
                        ),
                        itemCount: departures.length,
                        separatorBuilder:
                            (context, index) => Divider(
                              height: 1,
                              thickness: 1,
                              color: DesignSystem.grey100,
                              indent: DesignSystem.spacing20,
                              endIndent: DesignSystem.spacing20,
                            ),
                        itemBuilder: (context, index) {
                          final departure = departures[index];
                          return _DepartureListItem(
                            departure: departure,
                            stopName: selectedStop.name,
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

/// Individual departure list item
class _DepartureListItem extends StatelessWidget {
  const _DepartureListItem({required this.departure, required this.stopName});

  final Departure departure;
  final String stopName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacing20,
        vertical: DesignSystem.spacing12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TransportInfoWidget(transportMode: departure.transportMode),
                const SizedBox(height: DesignSystem.spacing12),
                Text(
                  departure.direction,
                  style: DesignSystem.titleLarge.copyWith(fontSize: 18),
                ),
                const SizedBox(height: DesignSystem.spacing4),
                Text(
                  _buildSubtitle(),
                  style: DesignSystem.bodyLarge.copyWith(
                    color: DesignSystem.grey600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignSystem.spacing12),
          _DepartureTimeStatusWidget(departure: departure),
        ],
      ),
    );
  }

  String _buildSubtitle() {
    if (departure.platform != null) {
      return '$stopName • Platform ${departure.platform}';
    }
    return stopName;
  }
}

/// Widget for displaying transport info (icon and line name)
class _TransportInfoWidget extends StatelessWidget {
  const _TransportInfoWidget({required this.transportMode});

  final TransportMode transportMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getTransportIcon(transportMode.type),
          color: _getTransportModeColor(transportMode.type),
          size: 20,
        ),
        const SizedBox(width: DesignSystem.spacing8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacing8,
            vertical: DesignSystem.spacing4,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: DesignSystem.grey300),
            borderRadius: BorderRadius.circular(DesignSystem.spacing4),
          ),
          child: Text(
            transportMode.name,
            style: DesignSystem.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  IconData _getTransportIcon(TransportType type) {
    switch (type) {
      case TransportType.subway:
        return Icons.directions_subway;
      case TransportType.suburban:
        return Icons.directions_railway;
      case TransportType.tram:
        return Icons.tram;
      case TransportType.bus:
        return Icons.directions_bus;
      case TransportType.ferry:
        return Icons.directions_boat;
      case TransportType.express:
        return Icons.directions_railway;
    }
  }

  Color _getTransportModeColor(TransportType type) {
    switch (type) {
      case TransportType.subway:
        return DesignSystem.subwayBlue;
      case TransportType.suburban:
        return DesignSystem.suburbanGreen;
      case TransportType.tram:
        return DesignSystem.tramRed;
      case TransportType.bus:
        return DesignSystem.busRed;
      case TransportType.ferry:
        return DesignSystem.ferryBlue;
      case TransportType.express:
        return DesignSystem.expressRed;
    }
  }
}

/// Widget for displaying departure time and status
class _DepartureTimeStatusWidget extends StatelessWidget {
  const _DepartureTimeStatusWidget({required this.departure});

  final Departure departure;

  @override
  Widget build(BuildContext context) {
    final isDelayed = departure.isDelayed;
    final statusText = departure.statusText;
    final backgroundColor =
        departure.cancelled
            ? DesignSystem.grey100
            : isDelayed
            ? DesignSystem.grey100
            : DesignSystem.grey50;
    final statusColor =
        departure.cancelled
            ? DesignSystem.red600
            : isDelayed
            ? DesignSystem.red600
            : DesignSystem.suburbanGreen;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacing12,
        vertical: DesignSystem.spacing8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(DesignSystem.spacing8),
      ),
      child: Column(
        children: [
          Text(
            _formatDepartureTime(departure.effectiveTime),
            style: DesignSystem.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: DesignSystem.spacing4),
          Text(
            statusText,
            style: DesignSystem.labelLarge.copyWith(
              color: statusColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDepartureTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Widget shown when no departures are available
class _EmptyDeparturesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: DesignSystem.grey500),
            const SizedBox(height: DesignSystem.spacing24),
            Text(
              'No departures found',
              style: DesignSystem.titleLarge.copyWith(
                color: DesignSystem.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignSystem.spacing8),
            Text(
              'There are currently no upcoming departures for this station.',
              style: DesignSystem.bodyLarge.copyWith(
                color: DesignSystem.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
