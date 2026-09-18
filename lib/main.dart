import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.bottomsheet.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'services/settings_service.dart';
import 'ui/common/app_background.dart';
import 'ui/common/app_widgets.dart';
import 'ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await setupLocator();
  setupBottomSheetUi();
  setupSnackbarUi();

  runApp(const TrueSizeApp());
}

/// Registers a default configuration for the [SnackbarService] so `showSnackbar`
/// calls actually render.
void setupSnackbarUi() {
  final service = locator<SnackbarService>();
  service.registerSnackbarConfig(
    SnackbarConfig(
      backgroundColor: const Color(0xFF202124),
      textColor: Colors.white,
      borderRadius: 12,
    ),
  );
}

/// Makes every scaffold (and app bar) transparent so the wallpaper behind the
/// navigator shows through. Used only while a background theme is active.
ThemeData _transparentScaffold(ThemeData theme) => theme.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: theme.appBarTheme.copyWith(backgroundColor: Colors.transparent),
    );

class TrueSizeApp extends StatelessWidget {
  const TrueSizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = locator<SettingsService>();
    return Sizer(
      builder: (context, orientation, deviceType) {
        // Rebuild the MaterialApp whenever theme mode, primary color or the
        // background wallpaper changes.
        return ListenableBuilder(
          listenable: settings,
          builder: (context, _) {
            final background = settings.backgroundTheme;
            final hasBackground = !background.isNone;
            final light = buildLightTheme(settings.primaryColor);
            final dark = buildDarkTheme(settings.primaryColor);
            // A wallpaper forces the dark, image-backed look: scaffolds turn
            // transparent so the global [AppBackdrop] shows through every route.
            final themed = hasBackground ? _transparentScaffold(dark) : null;
            return MaterialApp(
              title: 'TrueSize',
              debugShowCheckedModeBanner: false,
              theme: themed ?? light,
              darkTheme: themed ?? dark,
              themeMode: hasBackground ? ThemeMode.dark : settings.themeMode,
              navigatorKey: StackedService.navigatorKey,
              onGenerateRoute: StackedRouter().onGenerateRoute,
              initialRoute: Routes.startupView,
              builder: (context, child) {
                final mq = MediaQuery.of(context);
                // Trim overall type down a notch for a tighter, denser look
                // while still honouring the user's system text scale.
                final effective = mq.textScaler.scale(1) * 0.9;
                Widget content = MediaQuery(
                  data: mq.copyWith(textScaler: TextScaler.linear(effective)),
                  child: child!,
                );
                if (hasBackground) {
                  content = AppBackdrop(theme: background, child: content);
                }
                // Over a wallpaper, every plain SoftCard renders as frosted glass
                // so the image shows through consistently across all views.
                return SurfaceStyle(glass: hasBackground, child: content);
              },
            );
          },
        );
      },
    );
  }
}
