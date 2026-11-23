import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Travel classes on a train.
class ClassesFacilitiesScreen extends ConsumerWidget {
  const ClassesFacilitiesScreen({super.key, this.trainId, this.viewState});

  final String? trainId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(trainIdProvider(trainId));
    final train = resolved(ref, id, (v) => ref.watch(trainProvider(v))).value;
    final classes = resolved(
      ref,
      id,
      (v) => ref.watch(trainClassesProvider(v)),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.classesFacilities,
              subtitle: train == null
                  ? null
                  : '${train.name.of(context)} · #${train.number}',
            ),
            Expanded(
              child: AsyncView<List<TrainClass>?>(
                value: classes,
                state: viewState,
                isEmpty: (c) => c == null || c.isEmpty,
                content: (_, c) => _ClassesContent(classes: c!),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.event_seat_outlined,
                    title: l10n.emptyDetailsTitle,
                    message: l10n.classesNotListed,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(itemCount: 3, itemHeight: 140),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassesContent extends StatelessWidget {
  const _ClassesContent({required this.classes});

  final List<TrainClass> classes;

  static String _describe(String name) {
    if (name.startsWith('Observation')) {
      return 'Observation saloon at the end of the train with large windows.';
    }
    if (name.startsWith('Sleeper')) {
      return 'Night Mail sleeping berths and reclining sleeperettes.';
    }
    if (name.startsWith('1st')) return 'Air-conditioned or upholstered 1st class seats.';
    if (name.startsWith('2nd')) return 'Padded seats with fans and opening windows.';
    return 'Bench seating with fans; busiest on weekends and holidays.';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PageScroll(
      spacing: AppSpacing.md,
      children: [
        for (final c in classes)
          ClassCard(
            title: c.name,
            available: true,
            description: _describe(c.name),
            tags: [c.reservable ? l10n.reservedSeats : l10n.unreservedSeats],
          ),
        Text(
          l10n.timetableSourceNote('seat61.com'),
          style: AppTextStyles.caption.copyWith(color: context.palette.textMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: l10n.findTrainsWithClasses,
          tone: PrimaryButtonTone.dark,
          onPressed: () => context.go(AppRoutes.trains),
        ),
      ],
    );
  }
}

/// Travel class summary card.
class ClassCard extends StatelessWidget {
  const ClassCard({
    super.key,
    required this.title,
    required this.available,
    required this.description,
    this.tags = const [],
    this.fare,
  });

  final String title;
  final bool available;
  final String description;
  final List<String> tags;
  final String? fare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Opacity(
      opacity: available ? 1 : 0.72,
      child: AppCard(
        radius: AppRadii.cardLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: StatusChip(
                    label: available ? l10n.onThisTrain : l10n.notOnThisTrain,
                    tone: available ? StatusTone.mint : StatusTone.neutral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(color: palette.textMuted),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.s6,
                    runSpacing: AppSpacing.s6,
                    children: [
                      for (final t in tags)
                        StatusChip(label: t, tone: StatusTone.neutral),
                    ],
                  ),
                ),
                if (fare != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      fare!,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
