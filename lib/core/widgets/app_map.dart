import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../constants/app_assets.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'circle_icon_button.dart';

/// Tile URL for the map. Override with `null` in tests to skip network tiles.
final mapTileUrlProvider = Provider<String?>((ref) => AppConstants.osmTileUrl);

/// OpenStreetMap-backed map with the design's controls only.
///
/// No markers, routes or data are drawn — pass layers through [children]
/// later when real station / route data is available.
class AppMap extends ConsumerStatefulWidget {
  const AppMap({
    super.key,
    this.center = const LatLng(
      AppConstants.sriLankaLat,
      AppConstants.sriLankaLng,
    ),
    this.zoom = AppConstants.defaultMapZoom,
    this.children = const [],
    this.showZoomControls = true,
    this.controlsAlignment = Alignment.centerRight,
    this.controlsPadding = const EdgeInsets.all(AppSpacing.lg),
    this.dark = true,
  });

  final LatLng center;
  final double zoom;
  final List<Widget> children;
  final bool showZoomControls;
  final Alignment controlsAlignment;
  final EdgeInsets controlsPadding;

  /// Dims tiles to match the dark forest palette used for maps.
  final bool dark;

  @override
  ConsumerState<AppMap> createState() => _AppMapState();
}

class _AppMapState extends ConsumerState<AppMap> {
  final MapController _controller = MapController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoomBy(double delta) {
    final camera = _controller.camera;
    _controller.move(camera.center, camera.zoom + delta);
  }

  void _recenter() => _controller.move(widget.center, widget.zoom);

  @override
  Widget build(BuildContext context) {
    final tileUrl = ref.watch(mapTileUrlProvider);
    final l10n = context.l10n;
    return Semantics(
      label: l10n.mapLabel,
      child: ColoredBox(
        color: AppColors.forestDeep,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: widget.center,
                initialZoom: widget.zoom,
                backgroundColor: AppColors.forestDeep,
              ),
              children: [
                if (tileUrl != null)
                  _maybeDim(
                    TileLayer(
                      urlTemplate: tileUrl,
                      userAgentPackageName: AppConstants.userAgentPackage,
                    ),
                  ),
                ...widget.children,
              ],
            ),
            if (widget.showZoomControls)
              Align(
                alignment: widget.controlsAlignment,
                child: Padding(
                  padding: widget.controlsPadding,
                  child: MapControls(
                    onZoomIn: () => _zoomBy(1),
                    onZoomOut: () => _zoomBy(-1),
                    onRecenter: _recenter,
                  ),
                ),
              ),
            const Positioned(
              left: AppSpacing.sm,
              bottom: AppSpacing.xs,
              child: _Attribution(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _maybeDim(Widget tiles) {
    if (!widget.dark) return tiles;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.45, 0, 0, 0, 0, //
        0, 0.55, 0, 0, 4, //
        0, 0, 0.45, 0, 0, //
        0, 0, 0, 1, 0, //
      ]),
      child: tiles,
    );
  }
}

/// Vertical stack of map controls: zoom in, zoom out, re-centre.
class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onRecenter,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onRecenter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleIconButton(
          icon: Icons.add_rounded,
          tone: CircleIconTone.scrim,
          semanticLabel: l10n.zoomIn,
          onPressed: onZoomIn,
        ),
        const SizedBox(height: AppSpacing.sm),
        CircleIconButton(
          icon: Icons.remove_rounded,
          tone: CircleIconTone.scrim,
          semanticLabel: l10n.zoomOut,
          onPressed: onZoomOut,
        ),
        const SizedBox(height: AppSpacing.sm),
        CircleIconButton(
          icon: Icons.my_location_rounded,
          tone: CircleIconTone.accent,
          semanticLabel: l10n.recenterMap,
          onPressed: onRecenter,
        ),
      ],
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.mapAttribution,
      style: AppTextStyles.label.copyWith(
        fontSize: 9,
        color: AppColors.mutedOnDark,
      ),
    );
  }
}
