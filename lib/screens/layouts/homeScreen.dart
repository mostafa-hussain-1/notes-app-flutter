import 'package:flutter/material.dart';
import 'package:notes_app/modules/Notes_model.dart';
import 'package:notes_app/modules/Delete_model.dart';
import 'package:notes_app/modules/Archived_model.dart';

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
TextEditingController searchController =TextEditingController();


  int currentIndex =0;

  final List<String> _titles = [
  'Notes',
  'Trash',
  'Archived',
];

  List<Widget> screens = 
  [
    NotesModel(),
    DeleteModel(),
    ArchivedModel(),
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
            
          controller: searchController,
          keyboardType: TextInputType.text, //controller...

          )
                                             //other notes (after search box )

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
        //add note fun
      },
      child: Icon(Icons.add),
      ) :
      currentIndex ==1 ?FloatingActionButton
      (
        onPressed: ()
        {
          //delete all deleted notes fun
        },
        child: Icon(Icons.delete_outline_outlined),
      ):null
      
    
      

      
      
        
        
          
        
      
    );
  }
}