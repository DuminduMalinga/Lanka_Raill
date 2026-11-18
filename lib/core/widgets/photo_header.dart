import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_photo.dart';
import 'circle_icon_button.dart';

/// Photo hero at the top of detail screens: scrim buttons over the image,
/// tags + title + subtitle anchored to the bottom.
class PhotoHeader extends StatelessWidget {
  const PhotoHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.tags = const [],
    this.imageAsset,
    this.imageUrl,
    this.semanticLabel,
    this.actions = const [],
    this.height = 320,
    this.bottom,
    this.alignment = Alignment.center,
  });

  final String title;
  final String? subtitle;
  final List<Widget> tags;
  final String? imageAsset;
  final String? imageUrl;
  final String? semanticLabel;

  /// Trailing scrim buttons (share, save...).
  final List<Widget> actions;
  final double height;

  /// Optional widget placed under the subtitle (e.g. a code badge row).
  final Widget? bottom;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height + topInset),
        child: Stack(
          children: [
            Positioned.fill(
              child: AppPhoto(
                asset: imageAsset,
                imageUrl: imageUrl,
                semanticLabel: semanticLabel,
                radius: 0,
                alignment: alignment,
                placeholderColor: AppColors.forest,
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.3, 0.55, 1],
                    colors: [
                      Color(0x8C0B1912),
                      Color(0x000B1912),
                      Color(0x330B1912),
                      Color(0xF20B1912),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                topInset + AppSpacing.md,
                AppSpacing.gutter,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActionsRow(actions: actions),
                  SizedBox(height: height * 0.32),
                  _TitleBlock(
                    title: title,
                    subtitle: subtitle,
                    tags: tags,
                    bottom: bottom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: AppSizes.iconSm + 2,
          tone: CircleIconTone.scrim,
          semanticLabel: context.l10n.back,
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        const Spacer(),
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          actions[i],
        ],
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.title,
    required this.tags,
    this.subtitle,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final List<Widget> tags;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: tags,
          ),
          const SizedBox(height: AppSpacing.s10),
        ],
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppTextStyles.h2.copyWith(color: AppColors.white),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: AppTextStyles.body.copyWith(color: AppColors.captionOnDark),
          ),
        ],
        if (bottom != null) ...[const SizedBox(height: AppSpacing.md), bottom!],
      ],
    );
  }
}

/// Scrim circular action for [PhotoHeader.actions].
class HeaderAction extends StatelessWidget {
  const HeaderAction({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: icon,
      tone: CircleIconTone.scrim,
      semanticLabel: label,
      onPressed: onPressed ?? () {},
    );
  }
}

/// Light body that overlaps the hero with rounded top corners.
class DetailBody extends StatelessWidget {
  const DetailBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -AppSpacing.xl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.palette.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.xl,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          child: child,
        ),
      ),
    );
  }
}
