import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../features/auth/data/auth_errors.dart';
import '../../data/providers.dart';
import '../l10n/l10n.dart';
import '../router/app_routes.dart';
import '../state/ui_view_state.dart';
import 'buttons.dart';
import 'empty_state.dart';

/// Shows loading / empty / error / content for an [AsyncValue].
///
/// A forced [state] (or the global preview state when it isn't `content`)
/// wins, so previews and tests can still show each design state.
class AsyncView<T> extends ConsumerWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.content,
    required this.empty,
    required this.loading,
    this.isEmpty,
    this.state,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) content;
  final WidgetBuilder empty;
  final WidgetBuilder loading;
  final bool Function(T data)? isEmpty;
  final UiViewState? state;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = state ?? ref.watch(uiViewStateProvider);
    final Widget child;
    if (preview == UiViewState.empty) {
      child = empty(context);
    } else if (preview == UiViewState.loading) {
      child = loading(context);
    } else {
      child = switch (value) {
        AsyncData(:final value) when isEmpty?.call(value) ?? false => empty(
          context,
        ),
        AsyncData(:final value) => content(context, value),
        AsyncError() => LoadError(onRetry: onRetry),
        _ => loading(context),
      };
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: KeyedSubtree(key: ValueKey(child.runtimeType), child: child),
    );
  }
}

/// "Couldn't load" message with a retry button.
class LoadError extends StatelessWidget {
  const LoadError({super.key, this.onRetry, this.onDark = false});

  final VoidCallback? onRetry;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return EmptyState(
      icon: Icons.cloud_off_rounded,
      title: l10n.loadErrorTitle,
      message: l10n.loadErrorBody,
      onDark: onDark,
      action: onRetry == null
          ? null
          : SecondaryButton(
              label: l10n.retry,
              icon: Icons.refresh_rounded,
              expand: false,
              onPressed: onRetry,
            ),
    );
  }
}

/// Toggles a favourite; sends signed-out users to sign in.
Future<void> toggleFavorite(
  BuildContext context,
  WidgetRef ref,
  FavoriteKind kind,
  String id,
) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  if (!ref.read(isSignedInProvider)) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.signInToSave),
        action: SnackBarAction(
          label: l10n.signIn,
          onPressed: () => context.push(AppRoutes.signIn),
        ),
      ),
    );
    return;
  }
  final wasSaved = ref.read(favoritesProvider(kind)).value?.contains(id) ?? false;
  try {
    await ref.read(favoritesProvider(kind).notifier).toggle(id);
    messenger.showSnackBar(
      SnackBar(content: Text(wasSaved ? l10n.removedToast : l10n.savedToast)),
    );
  } on AuthException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(authErrorMessage(l10n, e))));
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.loadErrorBody)));
  }
}

/// Small grey photo credit line (Wikimedia licences require attribution).
class PhotoCredit extends StatelessWidget {
  const PhotoCredit(this.credit, {super.key, this.onDark = false});

  final String? credit;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final c = credit;
    if (c == null || c.isEmpty) return const SizedBox.shrink();
    return Text(
      context.l10n.photoCredit(c),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: onDark ? Colors.white70 : Theme.of(context).hintColor,
      ),
    );
  }
}
