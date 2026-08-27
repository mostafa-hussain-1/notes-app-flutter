import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/widgets/note_card.dart';

class DynamicNotesList extends StatelessWidget {
  final List<NoteModel> notes;
  final String type;

  const DynamicNotesList({super.key, required this.notes, required this.type});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(child: Text('There is nothing here!'));
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final currentNote = notes[index];
        return NoteCard(note: currentNote, type: type);
      },
    );
  }
}
