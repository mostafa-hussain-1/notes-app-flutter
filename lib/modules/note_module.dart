import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/functions/search.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/states/notes_cubit.dart';
import 'package:notes_app/states/notes_states.dart';
import 'package:notes_app/widgets/list_view.dart';

class NotesModule extends StatefulWidget {
  final String currentSearchText;
  const NotesModule({super.key, required this.currentSearchText});

  @override
  State<NotesModule> createState() => _NotesModuleState();
}

class _NotesModuleState extends State<NotesModule> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          else if (state is NotesSuccess) {
            List<NoteModel> displayList = searchNotes(state.activeNotes, widget.currentSearchText);
            
            return DynamicNotesList(notes: displayList);
          } 
          
          else if (state is NotesError) {
            return Center(child: Text(state.errorMessage));
          }

          return const Center(child: Text('There is nothing here!'));
        },
      )
    );
  }
}