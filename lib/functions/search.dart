import 'package:notes_app/models/notes_model.dart';

List<NoteModel> searchNotes(List<NoteModel> notes, String searchText) {
  final search = searchText.toLowerCase().trim();
  if (search.isEmpty) {
    return notes;
  }
  final List<NoteModel> filterNotes = notes.where((note) {
    final title = note.title.toLowerCase();
    final content = note.content.toLowerCase();
    return title.contains(search) || content.contains(search);
    }).toList();
  return filterNotes;
}
//done