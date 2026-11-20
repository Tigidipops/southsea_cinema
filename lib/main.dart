import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/views/settings_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefThemeMode = 'app_theme_mode';

bool isSupportedPlatform() {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  if (defaultTargetPlatform == TargetPlatform.windows) {
    return false;
  }
  return false;
}

void main() {
  if (isSupportedPlatform()) {
    runApp(const SouthseaCinemaApp());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves orders with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class SouthseaCinemaApp extends StatefulWidget {
  const SouthseaCinemaApp({super.key});

  @override
  State<SouthseaCinemaApp> createState() => _SouthseaCinemaAppState();
}

class _SouthseaCinemaAppState extends State<SouthseaCinemaApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? savedMode = await prefs.getString(prefThemeMode);

    if (!mounted) {
      return;
    }

    setState(() {
      _themeMode =
          savedMode == ThemeMode.light.name ? ThemeMode.light : ThemeMode.dark;
    });
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString(prefThemeMode, themeMode.name);

    if (!mounted) {
      return;
    }

    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeModeScope(
      themeMode: _themeMode,
      setThemeMode: setThemeMode,
      child: MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: cinemaLightTheme,
        darkTheme: cinemaDarkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeView(),
          '/listing': (context) => const MovieListing(),
          '/basket': (context) => const BasketView(),
          '/settings': (context) => const SettingsView(),
        },
      ),
    );
  }
}

class ThemeModeScope extends InheritedWidget {
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) setThemeMode;

  const ThemeModeScope({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  static ThemeModeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeModeScope>();
  }

  @override
  bool updateShouldNotify(ThemeModeScope oldWidget) {
    return themeMode != oldWidget.themeMode ||
        setThemeMode != oldWidget.setThemeMode;
  }
}
