import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_map.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/ui_state_view.dart';
import 'widgets/map_top_bar.dart';

/// Full-screen dark map for a train's route with a summary sheet.
class RouteMapScreen extends StatelessWidget {
  const RouteMapScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.forestDeep,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: AppMap(
                      controlsPadding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.xxl,
                      ),
                      controlsAlignment: Alignment.bottomRight,
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    // Overlays clip (rather than overflow) on short screens.
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Design preview content.
                          MapTopBar(
                            title: 'Main Line · Podi Menike',
                            fallbackRoute: AppRoutes.trainDetails,
                            trailing: CircleIconButton(
                              icon: Icons.layers_outlined,
                              tone: CircleIconTone.glass,
                              semanticLabel: l10n.mapLayers,
                              onPressed: () {},
                            ),
                          ),
                          if (viewState != UiViewState.empty)
                            const Padding(
                              padding: EdgeInsets.fromLTRB(
                                AppSpacing.gutter,
                                AppSpacing.xl,
                                0,
                                0,
                              ),
                              child: ScenicStretchCard(
                                title: 'Nanu Oya → Ella',
                                note: 'Sit on the right side for valley views',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _RouteSheet(viewState: viewState),
          ],
        ),
      ),
    );
  }
}

/// Small dark overlay card describing a scenic section of the route.
class ScenicStretchCard extends StatelessWidget {
  const ScenicStretchCard({super.key, required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.forestDeep.withValues(alpha: 0.9),
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.hairlineOnDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.landscape_outlined,
                size: 14,
                color: AppColors.lime,
              ),
              const SizedBox(width: AppSpacing.s6),
              Flexible(
                child: Text(
                  context.l10n.scenicStretch.toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.lime,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            title,
            style: AppTextStyles.bodyStrong.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            note,
            style: AppTextStyles.caption.copyWith(color: AppColors.mutedOnDark),
          ),
        ],
      ),
    );
  }
}

class _RouteSheet extends StatelessWidget {
  const _RouteSheet({this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.forestDeep.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: AppColors.hairlineOnDark)),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
      // Cap the sheet so the map stays visible; scroll when text is large.
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.62,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.md,
              AppSpacing.gutter,
              AppSpacing.lg,
            ),
            child: MaxWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SheetHandle(),
                  const SizedBox(height: AppSpacing.lg),
                  UiStateView(
                    state: viewState,
                    content: (_) => const _RouteSummary(),
                    empty: (_) => EmptyState(
                      onDark: true,
                      icon: Icons.map_outlined,
                      title: l10n.emptyDetailsTitle,
                      message: l10n.emptyDetailsBody,
                    ),
                    loading: (_) => const ShimmerList(
                      onDark: true,
                      itemCount: 2,
                      itemHeight: 64,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: l10n.stopTimeline,
                          icon: Icons.timeline_rounded,
                          tone: SecondaryButtonTone.glass,
                          onPressed: () => context.push(AppRoutes.stopTimeline),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s10),
                      Expanded(
                        child: PrimaryButton(
                          label: l10n.exploreStops,
                          icon: Icons.explore_outlined,
                          onPressed: () =>
                              context.push(AppRoutes.nearbyStations),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.25),
          borderRadius: AppRadii.pillAll,
        ),
      ),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Design preview content.
    return Column(
      children: [
        Row(
          children: [
            const IconTile(
              icon: Icons.route_rounded,
              size: 44,
              radius: AppRadii.iconTileLg,
              background: AppColors.lime,
              foreground: AppColors.ink,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Colombo Fort → Badulla',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Climbs from sea level to 1,898 m at Pattipola',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedOnDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        EqualRow(
          children: [
            StatTile(value: '≈290', label: l10n.km, onDark: true),
            StatTile(value: '10h 25m', label: l10n.journeyLower, onDark: true),
            StatTile(value: '10', label: l10n.majorStopsLower, onDark: true),
          ],
        ),
      ],
    );
  }
}
