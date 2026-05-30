import 'package:flutter/material.dart';
import 'package:lucid_reader/l10n/app_localizations.dart';

import '../features/library/presentation/library_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

abstract final class AppRoutes {
  static const library = '/';
  static const settings = '/settings';
}

abstract final class AppRouter {
  static Route<void> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      AppRoutes.library => const LibraryScreen(),
      AppRoutes.settings => const SettingsScreen(),
      _ => const _UnknownRouteScreen(),
    };

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.unknownRouteTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.unknownRouteMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
