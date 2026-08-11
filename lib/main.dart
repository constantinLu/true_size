// lib/main.dart (FIXED)
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.bottomsheet.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'app/app.theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //GoogleFonts.config.allowRuntimeFetching = false;
  // Initialize Firebase first
  await Firebase.initializeApp();

  // Setup Stacked locator with your services
  await setupLocator();
  setupBottomSheetUi();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        // Use with Google Fonts package to use downloadable fonts
        TextTheme textTheme = AppTheme.createTextTheme(context);
        return MaterialApp(
          title: 'TrueSize',
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: StackedRouter().onGenerateRoute,

          // Use your integrated theme with Google Fonts
          theme: AppTheme.lightTheme.copyWith(
            textTheme: textTheme.apply(
              bodyColor: AppTheme.onSurfaceLight,
              displayColor: AppTheme.onSurfaceLight,
            ),
          ),

          darkTheme: AppTheme.darkTheme.copyWith(
            textTheme: textTheme.apply(
              bodyColor: AppTheme.onSurfaceDark,
              displayColor: AppTheme.onSurfaceDark,
            ),
          ),
          // Default to dark theme
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
//
// @override
// Widget build(BuildContext context) {
//   return Sizer(
//     builder: (context, orientation, screenType) {
//       return ThemeBuilder(
//         themes: getThemes(),
//         statusBarColorBuilder: (theme) => Colors.yellow,
//         darkTheme: darkTheme,
//         lightTheme: lightTheme,
//         defaultThemeMode: darkTheme,
//         builder: (context, regularTheme, darkTheme, themeMode) {
//           return MaterialApp(
//             title: 'TrueSize',
//             theme: regularTheme,
//             darkTheme: darkTheme,
//             themeMode: themeMode,
//             navigatorKey: StackedService.navigatorKey,
//             onGenerateRoute: StackedRouter().onGenerateRoute,
//             debugShowCheckedModeBanner: false,
//           );
//         },
//       );
//     },
//   );
// }
// }
