import 'package:flutter/material.dart';
import 'package:lucid_reader/l10n/app_localizations.dart';

import '../../../app/router.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.libraryTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: 0,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (index) {
                    if (index == 1) {
                      Navigator.of(context).pushNamed(AppRoutes.settings);
                    }
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.library_books_outlined),
                      selectedIcon: const Icon(Icons.library_books),
                      label: Text(l10n.libraryTitle),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: Text(l10n.settingsTitle),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                const Expanded(child: _LibraryEmptyState()),
              ],
            );
          }

          return const _LibraryEmptyState();
        },
      ),
    );
  }
}

class _LibraryEmptyState extends StatelessWidget {
  const _LibraryEmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.emptyLibraryTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.emptyLibrarySubtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.importUnavailableMessage)),
                  );
                },
                icon: const Icon(Icons.upload_file_outlined),
                label: Text(l10n.importBookAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
