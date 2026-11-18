import 'package:material_ui/material_ui.dart';

import '../theme/app_spacing.dart';

/// Scrollable page body: centres content at [maxWidth] on wide screens and
/// keeps everything reachable at large text scales.
class PageScroll extends StatelessWidget {
  const PageScroll({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.gutter,
      AppSpacing.xs,
      AppSpacing.gutter,
      AppSpacing.xxl,
    ),
    this.spacing = AppSpacing.lg,
    this.maxWidth = AppSizes.maxContentWidth,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double spacing;
  final double maxWidth;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: spacing),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Constrains [child] to [maxWidth] and centres it (for non-scrolling areas).
class MaxWidth extends StatelessWidget {
  const MaxWidth({
    super.key,
    required this.child,
    this.maxWidth = AppSizes.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Scroll view whose child fills at least the viewport height, so layouts
/// can use [Spacer] yet still scroll on small phones / large text.
class FillScroll extends StatelessWidget {
  const FillScroll({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - padding.vertical).clamp(
                0,
                double.infinity,
              ),
            ),
            child: IntrinsicHeight(child: MaxWidth(child: child)),
          ),
        );
      },
    );
  }
}
