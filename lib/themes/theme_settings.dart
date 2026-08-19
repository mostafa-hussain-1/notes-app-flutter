import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ThemeSettings extends StatefulWidget {
final ThemeMode themeMode;
final Color primaryColor;
final List<Color> colors;

final Function(ThemeMode) changeTheme;
final Function(Color) changeColor;

const ThemeSettings({
super.key,
required this.themeMode,
required this.primaryColor,
required this.colors,
required this.changeTheme,
required this.changeColor,
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
                  groupValue: widget.themeMode,  
                  onChanged: (value) {  
                    widget.changeTheme(value!);  
                    setDialogState(() {});  
                  },  
                ),  

                RadioListTile<ThemeMode>(  
                  title: const Text("Dark"),  
                  value: ThemeMode.dark,  
                  groupValue: widget.themeMode,  
                  onChanged: (value) {  
                    widget.changeTheme(value!);  
                    setDialogState(() {});  
                  },  
                ),  

                RadioListTile<ThemeMode>(  
                  title: const Text("System"),  
                  value: ThemeMode.system,  
                  groupValue: widget.themeMode,  
                  onChanged: (value) {  
                    widget.changeTheme(value!);  
                    setDialogState(() {});  
                  },  
                ),  

                const Divider(),  

                const Text("Choose Color:"),  

                const SizedBox(height: 10),  

                ColorPicker(  
                  color: widget.primaryColor,  
                  onColorChanged: (color) {  
                    widget.changeColor(color);  
                    setDialogState(() {});  
                  },  
                ),  

                const SizedBox(height: 10),  

                if (widget.colors.isNotEmpty) ...[  
                  const Text("Recent Colors:"),  

                  const SizedBox(height: 8),  

                  Wrap(  
                    spacing: 8,  
                    children: widget.colors.map((color) {  
                      return GestureDetector(  
                        onTap: () {  
                          widget.changeColor(color);  
                          setDialogState(() {});  
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
