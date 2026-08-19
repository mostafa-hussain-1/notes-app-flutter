import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/functions/search.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/states/notes_cubit.dart';
import 'package:notes_app/states/notes_states.dart';
import 'package:notes_app/widgets/list_view.dart';

class DeleteModule extends StatefulWidget {
  final String currentSearchText;
  const DeleteModule({super.key, required this.currentSearchText});

  @override
  State<DeleteModule> createState() => _DeleteModuleState();
}

class _DeleteModuleState extends State<DeleteModule> {
  @override
  Widget build(BuildContext context) {
    return Expanded(

      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          
         else if (state is NotesSuccess) {
            List<NoteModel> displayList = searchNotes(state.trashNotes, widget.currentSearchText);
            
            if (displayList.isEmpty) {
              return const Center(child: Text('There is nothing here!'));
            }

            return Column(
              children: [
                Expanded(
                  child: DynamicNotesList(notes: displayList),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {

                        context.read<NotesCubit>().clearTrash();
                          //for clear note in trash code

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Clear Trash'),
                    ),
                  ),
                ),
              ],
            );
          } 
          
          else if (state is NotesError) {
            return Center(child: Text(state.errorMessage));
          }
          
          return const Center(child: Text('There is nothing here!'));
        },
      ),
    );
  }
}