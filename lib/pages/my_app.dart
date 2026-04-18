import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/pages/first_page.dart';
import 'package:smartwallet/pages/homepage.dart';
import 'package:smartwallet/setting/setting_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: WalletDb.instance.snapshot(),
        builder: (context, snapshot) {
          return AnimatedBuilder(
              animation: SettingsController.instance,
              builder: (context, snapshot) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: SettingsController.instance.themeMode,
                  theme: _buildTheme(Brightness.light),
                  darkTheme: _buildTheme(Brightness.dark),
                  home: (WalletDb.instance.getMoneyList().isEmpty)
                      ? const FirstPage()
                      : const HomePage(),
                );
              });
        });
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorSchemeSeed: Colors.greenAccent.shade400, // Expressive seed
    );
    final colorScheme = baseTheme.colorScheme;

    return baseTheme.copyWith(
      textTheme: GoogleFonts.ubuntuTextTheme(baseTheme.textTheme),
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: GoogleFonts.ubuntu(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28)), // Expressive radius
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        indicatorColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surface,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          side: BorderSide(color: colorScheme.outline, width: 1.5),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
