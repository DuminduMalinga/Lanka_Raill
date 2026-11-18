import 'package:material_ui/material_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/circle_icon_button.dart';

/// Dark forest "Where to next?" card: From / To, swap, date, Find trains.
class JourneyHeroCard extends StatelessWidget {
  const JourneyHeroCard({
    super.key,
    required this.from,
    required this.to,
    required this.dateLabel,
    this.onFromTap,
    this.onToTap,
    this.onSwap,
    this.onDateTap,
    this.onFindTrains,
  });

  final String from;
  final String to;
  final String dateLabel;
  final VoidCallback? onFromTap;
  final VoidCallback? onToTap;
  final VoidCallback? onSwap;
  final VoidCallback? onDateTap;
  final VoidCallback? onFindTrains;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s18),
      decoration: BoxDecoration(
        color: palette.hero,
        borderRadius: AppRadii.heroAll,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StationField(
                      label: l10n.from,
                      station: from,
                      onTap: onFromTap,
                    ),
                    const Divider(height: 20, color: AppColors.hairlineOnDark),
                    _StationField(label: l10n.to, station: to, onTap: onToTap),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              CircleIconButton(
                icon: Icons.swap_vert_rounded,
                tone: CircleIconTone.glass,
                semanticLabel: l10n.swapStations,
                onPressed: onSwap,
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: AppColors.lime,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          LayoutBuilder(
            builder: (context, constraints) {
              final date = _DatePill(label: dateLabel, onTap: onDateTap);
              final find = CompactPillButton(
                label: l10n.findTrains,
                icon: Icons.search_rounded,
                onPressed: onFindTrains,
              );
              // Stack the controls on narrow cards / large text.
              final narrow =
                  constraints.maxWidth <
                  280 * MediaQuery.textScalerOf(context).scale(1);
              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    date,
                    const SizedBox(height: AppSpacing.s10),
                    find,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: date),
                  const SizedBox(width: AppSpacing.s10),
                  find,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StationField extends StatelessWidget {
  const _StationField({required this.label, required this.station, this.onTap});

  final String label;
  final String station;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label $station',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.mutedOnDark,
                ),
              ),
              Text(
                station,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.travelDateLabel(label),
      excludeSemantics: true,
      child: Material(
        color: AppColors.white.withValues(alpha: 0.08),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: AppSizes.iconSm,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: AppColors.white,
                      ),
                    ),
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
