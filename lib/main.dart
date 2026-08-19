import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/screens/layouts/add_edit_note_screen.dart';
import 'package:notes_app/screens/layouts/home_screen.dart';
import 'package:notes_app/states/notes_cubit.dart';
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
    return BlocProvider(
      create: (context) => NotesCubit()..fetchAllNotes(),
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes APP',
        theme: AppThemes.getLightTheme(currentPrimaryColor),
        darkTheme: AppThemes.getDarkTheme(currentPrimaryColor),
        themeMode: ThemeMode.system,
        home: const AddEditNoteScreen(),
      ),
    ); 
  }
}