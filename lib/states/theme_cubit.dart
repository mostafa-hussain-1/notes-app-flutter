import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/states/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  ThemeMode appThemeMode = ThemeMode.system;
  Color primaryColor = const Color.fromARGB(255, 99, 39, 39);
  List<Color> recentColors = [];

  void changeTheme(ThemeMode mode) {
    appThemeMode = mode;
    emit(ThemeChanged());
  }

  void changeColor(Color color) {
    primaryColor = color;
    
    if (!recentColors.contains(color)) {
      recentColors.add(color);
    }
    
    emit(ThemeChanged());
  }
}