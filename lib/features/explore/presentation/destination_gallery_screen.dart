import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_photo.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Photo gallery for a destination with filters and an upload CTA.
class DestinationGalleryScreen extends ConsumerWidget {
  const DestinationGalleryScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(uiSelectionProvider(UiSelections.galleryFilter));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Design preview content.
            AppTopBar(
              title: 'Nine Arch Bridge',
              subtitle: l10n.galleryCount(6),
              trailing: CircleIconButton(
                icon: Icons.ios_share_rounded,
                semanticLabel: l10n.share,
                onPressed: () {},
              ),
            ),
            ChoicePillRow(
              labels: [
                l10n.galleryAll,
                l10n.galleryTrains,
                l10n.galleryViews,
                l10n.galleryTravellers,
              ],
              selectedIndex: filter,
              onSelected: (i) => ref
                  .read(
                    uiSelectionProvider(UiSelections.galleryFilter).notifier,
                  )
                  .select(i),
            ),
            Expanded(
              child: UiStateView(
                state: viewState,
                content: (_) => const _GalleryContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.photo_library_outlined,
                    title: l10n.emptyGalleryTitle,
                    message: l10n.emptyGalleryBody,
                  ),
                ),
                loading: (_) => const _GalleryLoading(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.sm,
                AppSpacing.gutter,
                AppSpacing.md,
              ),
              child: MaxWidth(
                child: PrimaryButton(
                  label: l10n.addYourPhoto,
                  icon: Icons.add_a_photo_outlined,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryContent extends StatelessWidget {
  const _GalleryContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Design preview content.
    return PageScroll(
      spacing: AppSpacing.s10,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.lg,
      ),
      children: [
        _GalleryRow(
          large: AppPhoto(
            asset: AppAssets.nineArchBridge,
            semanticLabel: l10n.welcomeImageAlt,
            radius: AppRadii.card,
          ),
          small: [
            AppPhoto(
              asset: AppAssets.nineArchBridge,
              semanticLabel: l10n.welcomeImageAlt,
              alignment: Alignment.centerRight,
              radius: AppRadii.card,
            ),
            _YourPhotoSlot(label: l10n.yourPhoto),
          ],
        ),
        _GalleryRow(
          reverse: true,
          large: AppPhoto(
            asset: AppAssets.mistyHillTrain,
            semanticLabel: l10n.mistyImageAlt,
            radius: AppRadii.card,
          ),
          small: [
            AppPhoto(
              asset: AppAssets.nineArchBridge,
              semanticLabel: l10n.welcomeImageAlt,
              alignment: Alignment.bottomLeft,
              radius: AppRadii.card,
            ),
            _YourPhotoSlot(label: l10n.yourPhoto),
          ],
        ),
      ],
    );
  }
}

/// Masonry-style row: one large photo and two stacked small ones.
class _GalleryRow extends StatelessWidget {
  const _GalleryRow({
    required this.large,
    required this.small,
    this.reverse = false,
  });

  final Widget large;
  final List<Widget> small;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Expanded(flex: 3, child: large),
      const SizedBox(width: AppSpacing.s10),
      Expanded(
        flex: 2,
        child: Column(
          children: [
            Expanded(child: small[0]),
            const SizedBox(height: AppSpacing.s10),
            Expanded(child: small[1]),
          ],
        ),
      ),
    ];
    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: reverse ? children.reversed.toList() : children,
      ),
    );
  }
}

class _YourPhotoSlot extends StatelessWidget {
  const _YourPhotoSlot({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: palette.tint,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.card),
          onTap: () {},
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_photo_alternate_outlined, color: palette.onTint),
                const SizedBox(height: AppSpacing.s6),
                Text(
                  label,
                  style: AppTextStyles.captionStrong.copyWith(
                    color: palette.onTint,
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

class _GalleryLoading extends StatelessWidget {
  const _GalleryLoading();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: AppSpacing.page,
      child: AppShimmer(
        child: Column(
          children: [
            SizedBox(height: AppSpacing.sm),
            ShimmerBox(height: 260, radius: AppRadii.card),
            SizedBox(height: AppSpacing.s10),
            ShimmerBox(height: 260, radius: AppRadii.card),
          ],
        ),
      ),
    );
  }
}
