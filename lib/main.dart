import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/screens/layouts/home_screen.dart';
import 'package:notes_app/states/notes_cubit.dart';
import 'package:notes_app/states/theme_cubit.dart';
import 'package:notes_app/states/theme_state.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesCubit()..fetchAllNotes()),
        BlocProvider(create: (context) => ThemeCubit(),),
      ],

      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          
          var themeCubit = context.read<ThemeCubit>(); 

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Notes APP',

            themeMode: themeCubit.appThemeMode,
            theme: AppThemes.getLightTheme(themeCubit.primaryColor),
            darkTheme: AppThemes.getDarkTheme(themeCubit.primaryColor),

            home: const HomePage(),
          );
        },
      ),
    );
  }
}