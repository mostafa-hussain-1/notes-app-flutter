import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/widgets/note_card.dart';

class DynamicNotesList extends StatelessWidget {
  final List<NoteModel> notes;

  const DynamicNotesList({Key? key, required this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(child: Text('There is Nothing'));
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final currentNote = notes[index];
        return NoteCard(note: currentNote,);
      },
    );
  }
}