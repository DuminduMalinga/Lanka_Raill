import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'circle_icon_button.dart';

/// White card with From / To station rows and a lime swap button.
class JourneyStationsCard extends StatelessWidget {
  const JourneyStationsCard({
    super.key,
    required this.fromLabel,
    required this.from,
    required this.toLabel,
    required this.to,
    this.fromCode,
    this.toCode,
    this.onFromTap,
    this.onToTap,
    this.onSwap,
  });

  final String fromLabel;
  final String from;
  final String toLabel;
  final String to;
  final String? fromCode;
  final String? toCode;
  final VoidCallback? onFromTap;
  final VoidCallback? onToTap;
  final VoidCallback? onSwap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s14),
      radius: AppRadii.cardLg,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              _StationRow(
                icon: Icons.trip_origin_rounded,
                label: fromLabel,
                station: from,
                code: fromCode,
                onTap: onFromTap,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 54),
                child: Divider(height: AppSpacing.lg, color: palette.border),
              ),
              _StationRow(
                icon: Icons.location_on_outlined,
                label: toLabel,
                station: to,
                code: toCode,
                onTap: onToTap,
              ),
            ],
          ),
          Positioned(
            right: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: palette.surface, width: 3),
              ),
              child: CircleIconButton(
                icon: Icons.swap_vert_rounded,
                tone: CircleIconTone.accent,
                semanticLabel: context.l10n.swapStations,
                onPressed: onSwap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StationRow extends StatelessWidget {
  const _StationRow({
    required this.icon,
    required this.label,
    required this.station,
    this.code,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String station;
  final String? code;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: onTap != null,
      label: '$label $station',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
          child: Row(
            children: [
              IconTile(icon: icon, size: 40, radius: AppRadii.iconTileLg),
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                    Text(
                      station,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (code != null)
                Padding(
                  // Leaves room for the overlapping swap button.
                  padding: const EdgeInsets.only(left: 72),
                  child: Text(
                    code!,
                    style: AppTextStyles.tag.copyWith(
                      fontSize: 12,
                      letterSpacing: 0.7,
                      color: palette.textMuted,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
