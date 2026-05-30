import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lucid_reader/l10n/app_localizations.dart';

import '../core/di/app_dependencies.dart';
import 'app_scope.dart';
import 'localization/app_locale_resolution.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class LucidReaderApp extends StatelessWidget {
  const LucidReaderApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final settingsController = dependencies.settingsController;

    return AppScope(
      dependencies: dependencies,
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (context, _) {
          final resolvedLocale = AppLocaleResolution.resolve(
            settingsController.appLocale ??
                WidgetsBinding.instance.platformDispatcher.locale,
            AppLocalizations.supportedLocales,
          );

          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(locale: resolvedLocale),
            darkTheme: AppTheme.dark(locale: resolvedLocale),
            themeMode: settingsController.themeMode,
            locale: settingsController.appLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            localeResolutionCallback: AppLocaleResolution.resolve,
            initialRoute: AppRoutes.library,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
