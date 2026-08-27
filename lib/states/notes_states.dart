import 'package:notes_app/models/notes_model.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesSuccess extends NotesState {
  final List<NoteModel> activeNotes;
  final List<NoteModel> archiveNotes;
  final List<NoteModel> trashNotes;

  NotesSuccess({
    required this.activeNotes,
    required this.archiveNotes,
    required this.trashNotes,
  });
}

class NotesError extends NotesState {
  final String errorMessage;
  NotesError({required this.errorMessage});
}
