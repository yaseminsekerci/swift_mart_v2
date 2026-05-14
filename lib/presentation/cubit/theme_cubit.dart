import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    primaryColor: const Color(0xFF00B4D8),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF00B4D8),
      secondary: Color(0xFF00B4D8),
      surface: Colors.white,
      onSurface: Color(0xFF1E293B),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    primaryColor: const Color(0xFF00B4D8),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00B4D8),
      secondary: Color(0xFF00B4D8),
      surface: Color(0xFF1E293B),
      onSurface: Colors.white,
    ),
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark
        ? _lightTheme
        : _darkTheme);
  }

  bool get isDark => state.brightness == Brightness.dark;
}