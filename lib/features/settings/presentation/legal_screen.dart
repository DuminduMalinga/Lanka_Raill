import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/page_scroll.dart';

enum LegalDoc { privacy, terms }

/// Privacy policy / terms of use, shown in-app.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.doc});

  final LegalDoc doc;

  static const _privacy = <(String, String)>[
    (
      'What we collect',
      'If you sign in, we store your email address, display name and profile '
          'photo (including the photo from your Google or Facebook account if '
          'you use it), plus the trains, stations and places you save. Any '
          'feedback you send is stored with the rating and message you write. To '
          'limit spam, feedback is also tagged with a one-way code made from '
          'your network address; the code changes every day and your '
          'address itself is not stored.',
    ),
    (
      'How we use it',
      'Only to run the app: to show your profile, keep your saved items in '
          'sync across devices and improve CeylonGO based on your feedback. '
          'We do not sell your data or show third-party ads.',
    ),
    (
      'Location',
      'Nearby stations use your location only while you ask for them. It is '
          'not stored on our servers.',
    ),
    (
      'Where it is kept',
      'Your data is held with our backend provider, Supabase. Photos you '
          'upload are stored in a public image bucket, so anyone with the '
          'link can view your profile picture.',
    ),
    (
      'Your choices',
      'You can edit your name and photo in Profile at any time, and sign out '
          'whenever you like. To delete your account, open Profile and choose '
          'Delete account. This permanently removes your profile, photo and '
          'saved items; feedback you sent is kept but no longer linked to you.',
    ),
  ];

  static const _terms = <(String, String)>[
    (
      'About CeylonGO',
      'CeylonGO is an independent travel companion for Sri Lanka\'s railways. '
          'It is not an official Sri Lanka Railways app and is not affiliated '
          'with or endorsed by Sri Lanka Railways.',
    ),
    (
      'Timetables',
      'Train times, delays and announcements are provided for guidance only '
          'and may be out of date or incomplete. Always confirm with the '
          'station or the official source before you travel. We are not '
          'responsible for missed trains or changed plans.',
    ),
    (
      'Your account',
      'Keep your sign-in details safe. You are responsible for what you '
          'upload, and you must not upload content that is unlawful, '
          'offensive or belongs to someone else.',
    ),
    (
      'Acceptable use',
      'Do not misuse the app, attempt to disrupt the service, or scrape its '
          'data in bulk.',
    ),
    (
      'Changes',
      'We may update the app and these terms from time to time. Continuing to '
          'use CeylonGO means you accept the updated terms.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final isPrivacy = doc == LegalDoc.privacy;
    final sections = isPrivacy ? _privacy : _terms;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: isPrivacy ? l10n.privacyPolicy : l10n.termsOfUse),
            Expanded(
              child: PageScroll(
                children: [
                  for (final (title, body) in sections)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          body,
                          style: AppTextStyles.body.copyWith(
                            color: palette.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  Text(
                    'Last updated 25 November 2026',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.mutedOnDark,
                    ),
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
