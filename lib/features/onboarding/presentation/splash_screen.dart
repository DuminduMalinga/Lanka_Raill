import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/photo_backdrop.dart';
import 'widgets/page_dots.dart';

/// Brand splash. Advances to Welcome after a short delay or on tap.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppDurations.splash, _continue);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _continue() {
    _timer?.cancel();
    if (mounted) context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.forest,
      body: ForestBackground(
        child: Semantics(
          button: true,
          label: l10n.splashContinue,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _continue,
            child: Stack(
              children: [
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 300,
                  child: _TrackPerspective(),
                ),
                const Center(child: _BrandBlock()),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: AppSpacing.huge + AppSpacing.xl,
                  child: _Footer(label: l10n.appSubtitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: AppSpacing.heroPage,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLogoMark(size: 96),
          const SizedBox(height: AppSpacing.s22),
          Text(
            l10n.appName,
            textAlign: TextAlign.center,
            style: AppTextStyles.splashBrand.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.appTagline,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.mutedOnDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageDots(count: 3, current: 0, activeWidth: 24, height: 6),
        const SizedBox(height: AppSpacing.s14),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.mutedOnDark,
            letterSpacing: 0.96,
          ),
        ),
      ],
    );
  }
}

/// Decorative rails + sleepers converging into the distance.
class _TrackPerspective extends StatelessWidget {
  const _TrackPerspective();

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(child: CustomPaint(painter: _TrackPainter()));
  }
}

class _TrackPainter extends CustomPainter {
  const _TrackPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 390;
    final sy = size.height / 300;
    final rails = Paint()
      ..color = AppColors.lime.withValues(alpha: 0.35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final sleepers = Paint()
      ..color = AppColors.lime.withValues(alpha: 0.14)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(Offset(150 * sx, 0), Offset(40 * sx, 300 * sy), rails)
      ..drawLine(Offset(240 * sx, 0), Offset(350 * sx, 300 * sy), rails);

    const rows = <(double, double, double)>[
      (140, 30, 110),
      (128, 70, 134),
      (112, 115, 166),
      (94, 165, 202),
      (72, 225, 246),
      (50, 290, 290),
    ];
    for (final (x, y, w) in rows) {
      canvas.drawLine(
        Offset(x * sx, y * sy),
        Offset((x + w) * sx, y * sy),
        sleepers,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
