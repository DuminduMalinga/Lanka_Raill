import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'status_chip.dart';

/// A tag shown on a train card.
@immutable
class TrainTag {
  const TrainTag(this.label, {this.tone = StatusTone.mint});
  final String label;
  final StatusTone tone;
}

/// Journey result card: name, number, depart → arrive with duration, classes.
class TrainCard extends StatelessWidget {
  const TrainCard({
    super.key,
    required this.trainName,
    required this.trainMeta,
    required this.departTime,
    required this.from,
    required this.arriveTime,
    required this.to,
    required this.duration,
    this.stopsLabel,
    this.arriveNote,
    this.tag,
    this.classes = const [],
    this.footer,
    this.highlighted = false,
    this.dimmed = false,
    this.onTap,
  });

  final String trainName;

  /// e.g. "#1005 · Express".
  final String trainMeta;
  final String departTime;
  final String from;
  final String arriveTime;
  final String to;
  final String duration;
  final String? stopsLabel;

  /// e.g. "+1 day".
  final String? arriveNote;
  final TrainTag? tag;
  final List<String> classes;
  final String? footer;
  final bool highlighted;
  final bool dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Opacity(
      opacity: dimmed ? 0.5 : 1,
      child: AppCard(
        onTap: onTap,
        radius: AppRadii.cardXl,
        borderColor: highlighted ? palette.primary : null,
        borderWidth: highlighted ? 2 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(name: trainName, meta: trainMeta, tag: tag),
            const SizedBox(height: AppSpacing.s14),
            _Times(
              departTime: departTime,
              from: from,
              arriveTime: arriveTime,
              to: to,
              duration: duration,
              stopsLabel: stopsLabel,
              arriveNote: arriveNote,
            ),
            if (classes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s14),
              Wrap(
                spacing: AppSpacing.s6,
                runSpacing: AppSpacing.s6,
                children: [
                  for (final c in classes)
                    StatusChip(label: c, tone: StatusTone.neutral),
                ],
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: AppSpacing.s10),
              Text(
                footer!,
                style: AppTextStyles.caption.copyWith(color: palette.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.meta, this.tag});

  final String name;
  final String meta;
  final TrainTag? tag;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        const IconTile(icon: Icons.train_outlined, size: 36),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.cardTitle.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              Text(
                meta,
                style: AppTextStyles.caption.copyWith(color: palette.textMuted),
              ),
            ],
          ),
        ),
        if (tag != null) StatusChip(label: tag!.label, tone: tag!.tone),
      ],
    );
  }
}

class _Times extends StatelessWidget {
  const _Times({
    required this.departTime,
    required this.from,
    required this.arriveTime,
    required this.to,
    required this.duration,
    this.stopsLabel,
    this.arriveNote,
  });

  final String departTime;
  final String from;
  final String arriveTime;
  final String to;
  final String duration;
  final String? stopsLabel;
  final String? arriveNote;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final time = AppTextStyles.timeLarge.copyWith(color: palette.textPrimary);
    final place = AppTextStyles.label.copyWith(color: palette.textMuted);
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fit(Text(departTime, style: time)),
              Text(from, style: place),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(
                duration,
                style: AppTextStyles.captionStrong.copyWith(
                  color: palette.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  _Dot(color: palette.primary),
                  Expanded(child: Container(height: 2, color: palette.border)),
                  _Dot(color: palette.primary, filled: false),
                ],
              ),
              if (stopsLabel != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  stopsLabel!,
                  style: AppTextStyles.label.copyWith(color: palette.textMuted),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _fit(Text(arriveTime, style: time), Alignment.centerRight),
              Text(
                arriveNote == null ? to : '$to · $arriveNote',
                textAlign: TextAlign.end,
                style: place,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Scales a time down rather than overflowing on narrow cards.
  static Widget _fit(
    Widget child, [
    Alignment alignment = Alignment.centerLeft,
  ]) => FittedBox(fit: BoxFit.scaleDown, alignment: alignment, child: child);
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, this.filled = true});

  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: filled ? color : context.palette.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}

/// Compact departure row: time + platform | name + subtitle | tag.
class TrainDepartureTile extends StatelessWidget {
  const TrainDepartureTile({
    super.key,
    required this.time,
    required this.trainName,
    required this.subtitle,
    this.platform,
    this.tag,
    this.showChevron = false,
    this.onTap,
  });

  final String time;
  final String trainName;
  final String subtitle;
  final String? platform;
  final TrainTag? tag;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.s14,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: AppTextStyles.timeMedium.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  if (platform != null)
                    Text(
                      platform!,
                      style: AppTextStyles.label.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s14),
            VerticalDivider(width: 1, thickness: 1, color: palette.border),
            const SizedBox(width: AppSpacing.s14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trainName,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (tag != null) StatusChip(label: tag!.label, tone: tag!.tone),
            if (showChevron)
              Icon(Icons.chevron_right_rounded, color: palette.textMuted),
          ],
        ),
      ),
    );
  }
}

/// Saved-train row: icon, name + number, route, next departure time.
class SavedTrainTile extends StatelessWidget {
  const SavedTrainTile({
    super.key,
    required this.trainName,
    required this.route,
    required this.nextDepartureLabel,
    required this.nextDepartureTime,
    this.onTap,
  });

  final String trainName;
  final String route;
  final String nextDepartureLabel;
  final String nextDepartureTime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s14),
      child: Row(
        children: [
          const IconTile(icon: Icons.bookmark_rounded, size: 42),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainName,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  route,
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  nextDepartureLabel,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.label.copyWith(color: palette.textMuted),
                ),
                Text(
                  nextDepartureTime,
                  style: AppTextStyles.timeMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
