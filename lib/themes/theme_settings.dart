import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/states/theme_cubit.dart';

class ThemeSettings extends StatefulWidget {

const ThemeSettings({
super.key,
});

@override
State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
void openTheme(BuildContext context) {
showDialog(
context: context,
builder: (context) {
return StatefulBuilder(
builder: (context, setDialogState) {
return AlertDialog(
title: const Text("Theme Settings"),

content: SingleChildScrollView(  
            child: Column(  
              mainAxisSize: MainAxisSize.min,  
              children: [  
                const Text("Choose Mode:"),  

                RadioListTile<ThemeMode>(  
                  title: const Text("Light"),  
                  value: ThemeMode.light,  
                  groupValue: context.read<ThemeCubit>().appThemeMode,                  
                  onChanged: (value) {  
                    context.read<ThemeCubit>().changeTheme(value!);
                  },  
                ),  

                RadioListTile<ThemeMode>(  
                  title: const Text("Dark"),  
                  value: ThemeMode.dark,  
                  groupValue: context.read<ThemeCubit>().appThemeMode,                  
                  onChanged: (value) {  
                    context.read<ThemeCubit>().changeTheme(value!);
                  },  
                ),

                RadioListTile<ThemeMode>(  
                  title: const Text("System"),  
                  value: ThemeMode.system,  
                  groupValue: context.read<ThemeCubit>().appThemeMode,                  
                  onChanged: (value) {  
                    context.read<ThemeCubit>().changeTheme(value!);
                  },   
                ),  

                const Divider(),  

                const Text("Choose Color:"),  

                const SizedBox(height: 10),  

                ColorPicker(  
                  color: context.read<ThemeCubit>().primaryColor,  
                  onColorChanged: (color) {  
                    context.read<ThemeCubit>().changeColor(color);    
                  },  
                ),  

                const SizedBox(height: 10),  

                if (context.read<ThemeCubit>().recentColors.isNotEmpty) ...[  
                  const Text("Recent Colors:"),  

                  const SizedBox(height: 8),  

                  Wrap(  
                    spacing: 8,  
                    children: context.read<ThemeCubit>().recentColors.map((color) {  
                      return GestureDetector(  
                        onTap: () {  
                          context.read<ThemeCubit>().changeColor(color);
                        },  

                        child: Container(  
                          width: 35,  
                          height: 35,  

                          decoration: BoxDecoration(  
                            color: color,  
                            shape: BoxShape.circle,  
                          ),  
                        ),  
                      );  
                    }).toList(),  
                  ),  
                ],  
              ],  
            ),  
          ),  
        );  
      },  
    );  
  },  
);

}

@override
Widget build(BuildContext context) {
return IconButton(
icon: const Icon(Icons.palette),
onPressed: () {
openTheme(context);
},
);
}
} 
