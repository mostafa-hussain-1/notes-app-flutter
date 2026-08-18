import 'package:flutter/material.dart';
import 'package:notes_app/screens/layouts/home_screen.dart';
import 'themes/app_theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color currentPrimaryColor;
    //currentPrimaryColor = context.watch<ThemeProvider>().primaryColor;
    currentPrimaryColor = Color.fromARGB(255, 50, 20, 30);
    
    //final currentThemeMode = context.watch<ThemeProvider>().themeMode;
    
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Notes APP',

      theme: AppThemes.getLightTheme(currentPrimaryColor),
      darkTheme: AppThemes.getDarkTheme(currentPrimaryColor),

      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}