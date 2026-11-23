import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

/// Centre and zoom that roughly fit [points] on a phone-sized map.
(LatLng, double) fitPoints(List<LatLng> points, {double fallbackZoom = 7.5}) {
  if (points.isEmpty) return (const LatLng(7.87, 80.77), fallbackZoom);
  if (points.length == 1) return (points.first, 13);
  var minLat = points.first.latitude, maxLat = minLat;
  var minLng = points.first.longitude, maxLng = minLng;
  for (final p in points) {
    minLat = math.min(minLat, p.latitude);
    maxLat = math.max(maxLat, p.latitude);
    minLng = math.min(minLng, p.longitude);
    maxLng = math.max(maxLng, p.longitude);
  }
  final span = math.max(maxLat - minLat, maxLng - minLng);
  final zoom = span > 3
      ? 6.8
      : span > 1.5
      ? 7.6
      : span > 0.7
      ? 8.6
      : span > 0.3
      ? 9.6
      : span > 0.12
      ? 10.8
      : 12.5;
  return (LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2), zoom);
}

/// A map pin with an optional short label (station code).
class MapPin extends StatelessWidget {
  const MapPin({super.key, this.label, this.highlighted = false, this.onTap});

  final String? label;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: highlighted ? 18 : 14,
            height: highlighted ? 18 : 14,
            decoration: BoxDecoration(
              color: highlighted ? AppColors.lime : AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ink, width: 2),
            ),
          ),
          if (label != null)
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.ink.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label!,
                textScaler: TextScaler.noScaling,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Polyline + pins for a route through [points].
List<Widget> routeLayers(
  List<(LatLng, String)> points, {
  Color color = AppColors.lime,
  void Function(int index)? onTap,
}) {
  return [
    if (points.length > 1)
      PolylineLayer(
        polylines: [
          Polyline(
            points: [for (final p in points) p.$1],
            color: color,
            strokeWidth: 4,
          ),
        ],
      ),
    MarkerLayer(
      markers: [
        for (var i = 0; i < points.length; i++)
          Marker(
            point: points[i].$1,
            width: 56,
            height: 46,
            alignment: Alignment.topCenter,
            child: MapPin(
              label: points[i].$2,
              highlighted: i == 0 || i == points.length - 1,
              onTap: onTap == null ? null : () => onTap(i),
            ),
          ),
      ],
    ),
  ];
}
