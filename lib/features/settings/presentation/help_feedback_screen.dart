import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/providers.dart';

/// FAQ accordion, star rating and feedback form (UI only).
class HelpFeedbackScreen extends ConsumerWidget {
  const HelpFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final open = ref.watch(uiSelectionProvider(UiSelections.helpFaqOpen));
    final faqs = [
      (l10n.faq1Q, l10n.faq1A),
      (l10n.faq2Q, l10n.faq2A),
      (l10n.faq3Q, l10n.faq3A),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.helpFeedback),
            Expanded(
              child: PageScroll(
                spacing: AppSpacing.md,
                children: [
                  AppSearchBar(hint: l10n.searchHelp),
                  AppCard(
                    padding: EdgeInsets.zero,
                    radius: AppRadii.cardLg,
                    child: Column(
                      children: [
                        for (var i = 0; i < faqs.length; i++) ...[
                          if (i > 0)
                            Divider(height: 1, color: context.palette.border),
                          FaqTile(
                            question: faqs[i].$1,
                            answer: faqs[i].$2,
                            expanded: open == i,
                            onTap: () => ref
                                .read(
                                  uiSelectionProvider(UiSelections.helpFaqOpen)
                                      .notifier,
                                )
                                .select(open == i ? -1 : i),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SectionLabel(l10n.sendFeedback),
                  const _FeedbackCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expandable question/answer row.
class FaqTile extends StatelessWidget {
  const FaqTile({
    super.key,
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: expanded,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: AppTextStyles.rowTitle.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      expanded ? Icons.remove_rounded : Icons.add_rounded,
                      color: palette.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: AppDurations.fast,
          alignment: Alignment.topCenter,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Text(
                    answer,
                    style: AppTextStyles.body.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _FeedbackCard extends ConsumerStatefulWidget {
  const _FeedbackCard();

  @override
  ConsumerState<_FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends ConsumerState<_FeedbackCard> {
  final _message = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final text = _message.text.trim();
    if (text.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackEmpty)));
      return;
    }
    setState(() => _sending = true);
    try {
      await ref.read(repositoryProvider).sendFeedback(
        rating: ref.read(uiSelectionProvider(UiSelections.feedbackRating)),
        message: text,
        appVersion: AppConstants.version,
      );
      _message.clear();
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackSent)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackFailed)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rating = ref.watch(uiSelectionProvider(UiSelections.feedbackRating));
    return AppCard(
      radius: AppRadii.cardLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: l10n.rating,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    tooltip: l10n.rateStars(i),
                    onPressed: () => ref
                        .read(
                          uiSelectionProvider(UiSelections.feedbackRating)
                              .notifier,
                        )
                        .select(i),
                    icon: Icon(
                      i <= rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 30,
                      color: i <= rating
                          ? AppColors.amberIcon
                          : context.palette.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextArea(
            label: l10n.yourMessage,
            hint: l10n.messageHint,
            controller: _message,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: l10n.sendFeedback,
            icon: Icons.send_rounded,
            tone: PrimaryButtonTone.dark,
            onPressed: _sending ? null : _send,
          ),
        ],
      ),
    );
  }
}
