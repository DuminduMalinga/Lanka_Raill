import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_photo.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Photo gallery for a destination (Wikimedia Commons, credited).
class DestinationGalleryScreen extends ConsumerWidget {
  const DestinationGalleryScreen({
    super.key,
    this.destinationId,
    this.viewState,
  });

  final String? destinationId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(destinationIdProvider(destinationId));
    final dest = resolved(ref, id, (v) => ref.watch(destinationProvider(v)));
    final d = dest.value;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: d?.name.of(context) ?? l10n.gallery,
              subtitle: d == null ? null : l10n.galleryCount(d.photos.length),
            ),
            Expanded(
              child: AsyncView<Destination?>(
                value: dest,
                state: viewState,
                isEmpty: (v) => v == null || v.photos.isEmpty,
                content: (_, v) => _GalleryContent(photos: v!.photos),
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
          ],
        ),
      ),
    );
  }
}

class _GalleryContent extends StatelessWidget {
  const _GalleryContent({required this.photos});

  final List<Photo> photos;

  Widget _photo(BuildContext context, int i, {Alignment? alignment}) {
    final p = photos[i];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _PhotoViewer(photos: photos, initial: i),
        ),
      ),
      child: AppPhoto(
        imageUrl: p.url,
        semanticLabel: p.credit,
        alignment: alignment ?? Alignment.center,
        radius: AppRadii.card,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < photos.length; i += 3) {
      final left = photos.length - i;
      if (left >= 3) {
        rows.add(
          _GalleryRow(
            reverse: (i ~/ 3).isOdd,
            large: _photo(context, i),
            small: [_photo(context, i + 1), _photo(context, i + 2)],
          ),
        );
      } else {
        rows.add(
          SizedBox(
            height: 180,
            child: Row(
              children: [
                for (var j = i; j < photos.length; j++) ...[
                  if (j > i) const SizedBox(width: AppSpacing.s10),
                  Expanded(child: _photo(context, j)),
                ],
              ],
            ),
          ),
        );
      }
    }
    return PageScroll(
      spacing: AppSpacing.s10,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.lg,
      ),
      children: rows,
    );
  }
}

/// Full-screen swipeable photo with its credit.
class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer({required this.photos, required this.initial});

  final List<Photo> photos;
  final int initial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initial),
        itemCount: photos.length,
        itemBuilder: (context, i) => Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                child: AppPhoto(
                  imageUrl: photos[i].url,
                  semanticLabel: photos[i].credit,
                  radius: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PhotoCredit(photos[i].credit, onDark: true),
            ),
          ],
        ),
      ),
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
