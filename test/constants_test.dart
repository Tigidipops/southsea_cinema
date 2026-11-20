import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/constants.dart';

void main() {
  group('Cinema themes', () {
    test('dark palette has dark surfaces and light text', () {
      expect(cinemaDarkPalette.brand, cinemaBrand);
      expect(cinemaDarkPalette.brandLight, cinemaBrandLight);
      expect(cinemaDarkPalette.brandDark, cinemaBrandDark);
      expect(cinemaDarkPalette.background, cinemaBackground);
      expect(cinemaDarkPalette.surface, cinemaSurface);
      expect(cinemaDarkPalette.fontPrimary, cinemaFontWhite);
      expect(cinemaDarkPalette.fontMuted, cinemaFontMuted);

      expect(cinemaDarkTheme.brightness, Brightness.dark);
      expect(
        cinemaDarkTheme.scaffoldBackgroundColor,
        cinemaDarkPalette.background,
      );
      expect(cinemaDarkTheme.colorScheme.surface, cinemaDarkPalette.surface);
    });

    test('light palette has light surfaces and dark text', () {
      expect(cinemaLightPalette.background, const Color(0xFFF7F8FA));
      expect(cinemaLightPalette.surface, const Color(0xFFFFFFFF));
      expect(cinemaLightPalette.fontPrimary, const Color(0xFF1B1E28));

      expect(cinemaLightTheme.brightness, Brightness.light);
      expect(
        cinemaLightTheme.scaffoldBackgroundColor,
        cinemaLightPalette.background,
      );
      expect(cinemaLightTheme.colorScheme.surface, cinemaLightPalette.surface);
    });

    test('both themes retain the cinema brand colours', () {
      expect(cinemaDarkTheme.colorScheme.primary, cinemaDarkPalette.brand);
      expect(cinemaLightTheme.colorScheme.primary, cinemaLightPalette.brand);
    });
  });
}
