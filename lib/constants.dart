import 'package:flutter/material.dart';

const String appTitle = 'Southsea Cinema & Arts Centre.';

const Color cinemaBrand = Color(0xFF55BEDE);
const Color cinemaBrandLight = Color(0xFF7FCEE6);
const Color cinemaBrandDark = Color(0xFF3FB5D9);

const Color cinemaBackground = Color(0xFF1B1E28);
const Color cinemaFontWhite = Color(0xFFFFFFFF);
const Color cinemaFontMuted = Color(0xFF8A90A0);
const Color cinemaSurface = Color(0xFF242936);

const TextStyle cinemaHeaderStyle = TextStyle(
  color: cinemaFontWhite,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle cinemaMovieDescriptionStyle = TextStyle(
  color: cinemaFontWhite,
  fontSize: 18,
);

const largeScreenMinWidth = 600;

class CinemaColorPalette {
  final Color brand;
  final Color brandLight;
  final Color brandDark;
  final Color background;
  final Color fontPrimary;
  final Color fontMuted;
  final Color surface;

  const CinemaColorPalette({
    required this.brand,
    required this.brandLight,
    required this.brandDark,
    required this.background,
    required this.fontPrimary,
    required this.fontMuted,
    required this.surface,
  });
}

const CinemaColorPalette cinemaDarkPalette = CinemaColorPalette(
  brand: cinemaBrand,
  brandLight: cinemaBrandLight,
  brandDark: cinemaBrandDark,
  background: cinemaBackground,
  fontPrimary: cinemaFontWhite,
  fontMuted: cinemaFontMuted,
  surface: cinemaSurface,
);

const CinemaColorPalette cinemaLightPalette = CinemaColorPalette(
  brand: cinemaBrand,
  brandLight: cinemaBrandLight,
  brandDark: cinemaBrandDark,
  background: Color(0xFFF7F8FA),
  fontPrimary: Color(0xFF1B1E28),
  fontMuted: Color(0xFF667085),
  surface: Color(0xFFFFFFFF),
);

CinemaColorPalette cinemaPaletteFor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? cinemaDarkPalette
      : cinemaLightPalette;
}

ThemeData buildCinemaTheme(CinemaColorPalette palette, Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;
  final ThemeData base = isDark ? ThemeData.dark() : ThemeData.light();

  return base.copyWith(
    scaffoldBackgroundColor: palette.background,
    appBarTheme: AppBarTheme(
      backgroundColor: palette.surface,
      foregroundColor: palette.fontPrimary,
      iconTheme: IconThemeData(color: palette.brand),
      titleTextStyle: TextStyle(
        color: palette.fontPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: palette.brand,
      primary: palette.brand,
      surface: palette.surface,
      onSurface: palette.fontPrimary,
      brightness: brightness,
    ).copyWith(
      onPrimary: palette.fontPrimary,
      onSurface: palette.fontPrimary,
    ),
  );
}

ThemeData get cinemaDarkTheme =>
    buildCinemaTheme(cinemaDarkPalette, Brightness.dark);

ThemeData get cinemaLightTheme =>
    buildCinemaTheme(cinemaLightPalette, Brightness.light);
