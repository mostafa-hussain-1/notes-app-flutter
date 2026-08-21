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
      case 'light':
        appThemeMode = ThemeMode.light;
      case 'dark':
        appThemeMode = ThemeMode.dark;
      case 'system':
      default:
        appThemeMode = ThemeMode.system;
    }
  }

  void getThemeSettings(){
    getAppColor();
    getAppTheme();
  }

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