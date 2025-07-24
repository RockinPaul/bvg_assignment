import 'package:flutter/material.dart';

import '../../core/constants/design_system.dart';
import '../../domain/entities/bvg_stop.dart';

/// Widget displaying search suggestions for BVG stops
class StopsSuggestionsWidget extends StatelessWidget {
  const StopsSuggestionsWidget({
    super.key,
    required this.stops,
    required this.onStopSelected,
  });

  final List<BvgStop> stops;
  final ValueChanged<BvgStop> onStopSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacing20,
      ),
      itemCount: stops.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 1,
        color: DesignSystem.grey100,
        indent: DesignSystem.spacing16,
        endIndent: DesignSystem.spacing16,
      ),
      itemBuilder: (context, index) {
        final stop = stops[index];
        return _StopListItem(
          stop: stop,
          onTap: () => onStopSelected(stop),
        );
      },
    );
  }
}

/// Individual stop list item component
class _StopListItem extends StatelessWidget {
  const _StopListItem({
    required this.stop,
    required this.onTap,
  });

  final BvgStop stop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: DesignSystem.listItemHeight,
        padding: const EdgeInsets.symmetric(
          vertical: DesignSystem.spacing12,
        ),
        child: Row(
          children: [
            // Leading icon
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: DesignSystem.primaryText,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: DesignSystem.backgroundPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: DesignSystem.spacing12),
            
            // Stop information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stop.name,
                    style: DesignSystem.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (stop.products != null) ...[
                    const SizedBox(height: DesignSystem.spacing2),
                    _TransportModeIndicators(products: stop.products!),
                  ],
                ],
              ),
            ),
            
            // Trailing icon
            Icon(
              Icons.arrow_forward_ios,
              color: DesignSystem.primaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget showing available transport modes at a stop
class _TransportModeIndicators extends StatelessWidget {
  const _TransportModeIndicators({
    required this.products,
  });

  final Products products;

  @override
  Widget build(BuildContext context) {
    final availableModes = <Widget>[];

    if (products.subway) {
      availableModes.add(_ModeIndicator(
        label: 'U',
        color: DesignSystem.subwayBlue,
      ));
    }
    if (products.suburban) {
      availableModes.add(_ModeIndicator(
        label: 'S',
        color: DesignSystem.suburbanGreen,
      ));
    }
    if (products.bus) {
      availableModes.add(_ModeIndicator(
        label: 'Bus',
        color: DesignSystem.busRed,
      ));
    }
    if (products.tram) {
      availableModes.add(_ModeIndicator(
        label: 'Tram',
        color: DesignSystem.tramRed,
      ));
    }
    if (products.ferry) {
      availableModes.add(_ModeIndicator(
        label: 'Ferry',
        color: DesignSystem.ferryBlue,
      ));
    }
    if (products.express || products.regional) {
      availableModes.add(_ModeIndicator(
        label: 'RE',
        color: DesignSystem.expressRed,
      ));
    }

    if (availableModes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: availableModes
          .take(4) // Limit to 4 indicators to avoid overflow
          .expand((indicator) => [
                indicator,
                const SizedBox(width: DesignSystem.spacing4),
              ])
          .toList()
        ..removeLast(), // Remove last spacing
    );
  }
}

/// Individual transport mode indicator
class _ModeIndicator extends StatelessWidget {
  const _ModeIndicator({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacing4,
        vertical: DesignSystem.spacing2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
