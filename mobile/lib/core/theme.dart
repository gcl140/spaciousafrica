import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const gold = Color(0xFFC9A84C);
const goldLight = Color(0xFFE8A838);
const burnOrange = Color(0xFFE8875A);
const appBg = Color(0xFF08080F);
const surface = Color(0xFF12121A);
const cardBg = Color(0xFF1A1A26);

const primaryGradient = LinearGradient(
  colors: [gold, burnOrange],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const heroGradient = LinearGradient(
  colors: [Color(0xFF1A0A2E), Color(0xFF0D0D0D), Color(0xFF1A0A00)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: appBg,
  colorScheme: const ColorScheme.dark(
    primary: gold,
    secondary: burnOrange,
    surface: surface,
    onPrimary: Colors.black,
    onSurface: Color(0xFFF0F0F0),
  ),
  cardTheme: CardThemeData(
    color: cardBg,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.dmSans(
      color: const Color(0xFFF0F0F0),
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    iconTheme: const IconThemeData(color: Color(0xFFF0F0F0)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0E0E18),
    selectedItemColor: gold,
    unselectedItemColor: Color(0xFF555566),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  textTheme: GoogleFonts.dmSansTextTheme(
    const TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Color(0xFFF0F0F0),
        letterSpacing: -1.0,
        height: 1.1,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF0F0F0),
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF0F0F0),
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        color: Color(0xFF888899),
        height: 1.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: gold,
        letterSpacing: 0.8,
      ),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFF1E1E2E),
    thickness: 1,
  ),
);
