import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_backdrop.dart';
import 'widgets/page_dots.dart';

/// Three-step intro: timetables, scenic routes, verified announcements.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const int _pageCount = 3;

  /// Photo focal point per step (matches the design's object-position).
  static const List<Alignment> _focus = [
    Alignment(-0.2, 0.2),
    Alignment(-0.4, -0.1),
    Alignment(0.2, 0.6),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final step = ref.watch(uiSelectionProvider(UiSelections.onboardingStep));
    final titles = [
      l10n.onboardingTitle1,
      l10n.onboardingTitle2,
      l10n.onboardingTitle3,
    ];
    final bodies = [
      l10n.onboardingBody1,
      l10n.onboardingBody2,
      l10n.onboardingBody3,
    ];
    final isLast = step == _pageCount - 1;
    void goLanguage() => context.push(AppRoutes.languageSelect);

    return Scaffold(
      backgroundColor: AppColors.forest,
      body: ForestBackground(
        child: SafeArea(
          child: FillScroll(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopRow(onSkip: goLanguage),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.lg,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: _PhotoCard(alignment: _focus[step]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.heroGutter,
                    AppSpacing.xxl,
                    AppSpacing.heroGutter,
                    0,
                  ),
                  child: _StepCopy(
                    step: step,
                    count: _pageCount,
                    title: titles[step],
                    body: bodies[step],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.heroGutter,
                    AppSpacing.xxl,
                    AppSpacing.heroGutter,
                    AppSpacing.xxl,
                  ),
                  child: isLast
                      ? PrimaryButton(
                          label: l10n.chooseLanguage,
                          icon: Icons.explore_outlined,
                          onPressed: goLanguage,
                        )
                      : PrimaryButton(
                          label: l10n.next,
                          trailingIcon: Icons.arrow_forward_rounded,
                          onPressed: () => ref
                              .read(
                                uiSelectionProvider(UiSelections.onboardingStep)
                                    .notifier,
                              )
                              .select(step + 1),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.sm,
        0,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppBrand(markSize: 32, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.mutedOnDark,
              minimumSize: const Size(AppSizes.tapTarget, AppSizes.tapTarget),
              textStyle: AppTextStyles.bodyStrong,
            ),
            child: Text(context.l10n.skip),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final height = (MediaQuery.sizeOf(context).height * 0.46).clamp(
      260.0,
      400.0,
    );
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.photo),
            child: Image.asset(
              AppAssets.nineArchBridge,
              fit: BoxFit.cover,
              alignment: alignment,
              semanticLabel: l10n.welcomeImageAlt,
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            top: AppSpacing.lg,
            child: _NextStopCard(
              label: l10n.onboardingNextStop,
              value: l10n.onboardingNextStopValue,
            ),
          ),
          Positioned(
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: _DistancePill(label: l10n.onboardingDistance),
          ),
        ],
      ),
    );
  }
}

class _NextStopCard extends StatelessWidget {
  const _NextStopCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s10,
        AppSpacing.s10,
        AppSpacing.s14,
        AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: AppColors.forestDeep.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(AppRadii.iconTile),
            ),
            child: const Icon(
              Icons.directions_railway_outlined,
              size: 18,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: AppSpacing.s10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.mutedOnDark,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyStrong.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DistancePill extends StatelessWidget {
  const _DistancePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 15,
            color: AppColors.ink,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.tag.copyWith(
              fontSize: 12,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCopy extends StatelessWidget {
  const _StepCopy({
    required this.step,
    required this.count,
    required this.title,
    required this.body,
  });

  final int step;
  final int count;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageDots(
          count: count,
          current: step,
          semanticLabel: context.l10n.onboardingStep(step + 1, count),
        ),
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppTextStyles.h2.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          body,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.mutedOnDark,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
