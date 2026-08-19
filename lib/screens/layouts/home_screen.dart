import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/modules/archived_module.dart';
import 'package:notes_app/modules/deleted_module.dart';
import 'package:notes_app/modules/note_module.dart';
import 'package:notes_app/screens/layouts/add_edit_note_screen.dart';
import 'package:notes_app/states/notes_cubit.dart';


String searchQuery = '';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  
  final TextEditingController _searchController = TextEditingController();  //vars for controll

  @override
  void dispose() {
_searchController.dispose(); //for cleaning history
    super.dispose();
}
//controllers
TextEditingController searchController = TextEditingController();


  int currentIndex =0;

  final List<String> _titles = [
  'Notes',
  'Trash',
  'Archived',
];

  List<Widget> screens = 
  [
    NotesModule(currentSearchText: searchQuery,),
    DeleteModule(currentSearchText: searchQuery,),
    ArchivedModule(currentSearchText: searchQuery,),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold
    (
      appBar: AppBar
      (
        title:
        Text(_titles[currentIndex],style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        actions:
         [
          Padding(padding: EdgeInsets.all(12),
          child: IconButton(
            onPressed:()
            {
              //for change theme
            } ,
            icon:Icon(Icons.format_color_fill)
            )
            )
         ],
      ),
      body:Padding
      (padding: EdgeInsets.all(20),
      child: Column
      (
        children: 
        [
          TextFormField
          (
            decoration: InputDecoration
            (
              border: OutlineInputBorder
              (
                borderRadius: BorderRadius.circular(25)
              ),
              hintText: 'Search here',
              prefixIcon: Icon(Icons.search_outlined),
            ),
          onChanged: (value)
          {
            context.read<NotesCubit>().searchInNotes(value);
          },
          keyboardType: TextInputType.text, //controller...
          ),
          screens[currentIndex],
        ],
      ),
      ),
      bottomNavigationBar: BottomNavigationBar
      (currentIndex: currentIndex,
      onTap: (index)
      {
        setState(() 
        {
        currentIndex =index;
        });
      },
      //selectedItemColor: ,      for color
        items:
        [
        BottomNavigationBarItem(
        icon: Icon(Icons.note),
        label: 'Notes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.delete_forever_rounded),
        label: 'Trash',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.archive_rounded),
        label: 'Archived',
      )
        ],
        
      ),
      floatingActionButton: 
      currentIndex==0 ?FloatingActionButton
      (onPressed:()
      {
      Navigator.push
      (
        context,
        MaterialPageRoute
        (
          builder: (context)=>AddEditNoteScreen()
          )
      );
      },
      child: Icon(Icons.add),
      ) :null
    );
  }
}