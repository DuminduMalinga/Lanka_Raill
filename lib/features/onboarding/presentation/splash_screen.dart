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
import '../../auth/data/auth_service.dart';
import 'widgets/page_dots.dart';

/// Brand splash. Advances to Home (signed in) or Welcome after a short delay
/// or on tap.
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
    if (!mounted) return;
    final signedIn = AuthService.currentSession != null;
    context.go(signedIn ? AppRoutes.home : AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: ForestBackground(
        color: AppColors.charcoal,
        child: Semantics(
          button: true,
          label: l10n.splashContinue,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _continue,
            child: Stack(
              children: [
                const Positioned.fill(child: _GlowBackground()),
                const Align(
                  alignment: Alignment(0, -0.22),
                  child: _BrandBlock(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: AppSpacing.huge + AppSpacing.md,
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

/// Mint glows top-left and bottom-right, a grey haze top-right.
class _GlowBackground extends StatelessWidget {
  const _GlowBackground();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _glow(const Alignment(-1, -0.76), AppColors.glowGreen, 0.85, 0.84),
          _glow(const Alignment(1, -1), AppColors.glowGrey, 0.75, 0.8),
          _glow(const Alignment(0.7, 1), AppColors.glowGreen, 0.8, 0.9),
        ],
      ),
    );
  }

  Widget _glow(Alignment center, Color color, double alpha, double radius) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: center,
          radius: radius,
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: 0),
          ],
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
          const AppLogoMark(size: 150, glow: true),
          const SizedBox(height: 26),
          Text(
            l10n.appName,
            textAlign: TextAlign.center,
            style: AppTextStyles.splashBrand.copyWith(
              color: AppColors.white,
              fontSize: 40,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.appTagline,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.softOnCharcoal,
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
        const PageDots(
          count: 3,
          current: 0,
          activeWidth: 24,
          height: 6,
          activeColor: AppColors.signal,
          inactiveAlpha: 0.35,
        ),
        const SizedBox(height: AppSpacing.s14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0x8C141616),
            borderRadius: AppRadii.pillAll,
            border: Border.all(color: AppColors.signal.withValues(alpha: 0.45)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: AppTextStyles.captionStrong.copyWith(
                color: AppColors.signal,
                fontSize: 11,
                letterSpacing: 0.88,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
