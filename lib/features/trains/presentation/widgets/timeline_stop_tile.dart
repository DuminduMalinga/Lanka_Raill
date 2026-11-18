import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/status_chip.dart';

/// One row of the stop timeline: time · dot/rail · station + note.
class TimelineStopTile extends StatelessWidget {
  const TimelineStopTile({
    super.key,
    required this.time,
    required this.station,
    this.note,
    this.tag,
    this.tagTone = StatusTone.lime,
    this.isEndpoint = false,
    this.isLast = false,
    this.onTap,
  });

  final String time;
  final String station;
  final String? note;
  final String? tag;
  final StatusTone tagTone;

  /// First / last station: larger filled dot and bolder text.
  final bool isEndpoint;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 48,
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  time,
                  style: AppTextStyles.timeSmall.copyWith(
                    color: palette.textPrimary,
                    fontWeight: isEndpoint ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _Rail(isEndpoint: isEndpoint, isLast: isLast),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _Texts(
                  station: station,
                  note: note,
                  tag: tag,
                  tagTone: tagTone,
                  emphasised: isEndpoint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.isEndpoint, required this.isLast});

  final bool isEndpoint;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dot = isEndpoint
        ? Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: palette.primary,
              shape: BoxShape.circle,
              border: Border.all(color: palette.tint, width: 3),
            ),
          )
        : Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: palette.surface,
              shape: BoxShape.circle,
              border: Border.all(color: palette.primary, width: 2),
            ),
          );
    return SizedBox(
      width: 22,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxs),
          dot,
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                color: palette.primary.withValues(alpha: 0.35),
              ),
            ),
        ],
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({
    required this.station,
    required this.emphasised,
    required this.tagTone,
    this.note,
    this.tag,
  });

  final String station;
  final String? note;
  final String? tag;
  final StatusTone tagTone;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.s6,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              station,
              style:
                  (emphasised
                          ? AppTextStyles.cardTitle
                          : AppTextStyles.rowTitle)
                      .copyWith(color: palette.textPrimary),
            ),
            if (tag != null) StatusChip(label: tag!, tone: tagTone),
          ],
        ),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            note!,
            style: AppTextStyles.caption.copyWith(color: palette.textMuted),
          ),
        ],
      ],
    );
  }
}
