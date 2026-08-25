import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/states/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  late ThemeMode appThemeMode;
  late Color primaryColor;
  List<Color> recentColors = [];

  void saveAppColor(Color color) {
    var box = Hive.box('settings_box');
    box.put('app_color', color.value);
  }

  void getAppColor() {
    var box = Hive.box('settings_box');
    int color = box.get('app_color', defaultValue: 0xFF2196F3);
    primaryColor = Color(color);
  }

  void saveAppTheme(String theme) {
    var box = Hive.box('settings_box');
    box.put('app_theme', theme);
  }

  void getAppTheme() {
    var box = Hive.box('settings_box');

    String savedTheme = box.get('app_theme', defaultValue: 'system');

    switch (savedTheme) {
      case 'ThemeMode.light':
        appThemeMode = ThemeMode.light;
      case 'ThemeMode.dark':
        appThemeMode = ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        appThemeMode = ThemeMode.system;
    }
  }

  void loadRecentColors() {
    var box = Hive.box('settings_box');

    List<dynamic> savedColors = box.get('recent_colors', defaultValue: []);

    recentColors = savedColors
        .map((colorValue) => Color(colorValue as int))
        .toList();
  }

  void addColorToRecent(Color newColor) {
    var box = Hive.box('settings_box');

    List<dynamic> savedColors = box.get('recent_colors', defaultValue: []);

    int newColorValue = newColor.value;

    savedColors.remove(newColorValue);

    savedColors.insert(0, newColorValue);

    if (savedColors.length > 5) {
      savedColors = savedColors.sublist(0, 5);
    }

    box.put('recent_colors', savedColors);

    loadRecentColors();
  }

  void getThemeSettings() {
    getAppColor();
    getAppTheme();
    loadRecentColors();
  }

  void changeTheme(ThemeMode mode) {
    appThemeMode = mode;
    saveAppTheme(mode.toString());
    emit(ThemeChanged());
  }

  void changeColor(Color color) {
    primaryColor = color;

    addColorToRecent(color);

    emit(ThemeChanged());
  }
}
