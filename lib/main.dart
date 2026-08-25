import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/screens/layouts/home_screen.dart';
import 'package:notes_app/states/notes_cubit.dart';
import 'package:notes_app/states/theme_cubit.dart';
import 'package:notes_app/states/theme_state.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(NoteTypeAdapter());
  Hive.registerAdapter(NoteModelAdapter());

  await Hive.openBox<NoteModel>('notes_box');
  await Hive.openBox('settings_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesCubit()..fetchAllNotes()),
        BlocProvider(create: (context) => ThemeCubit()..getThemeSettings()),
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
