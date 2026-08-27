import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/states/notes_states.dart';
import 'package:notes_app/functions/search.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  List<NoteModel> activeNotes = [];
  List<NoteModel> archiveNotes = [];
  List<NoteModel> trashNotes = [];

  void fetchAllNotes() {
    emit(NotesLoading());

    var box = Hive.box<NoteModel>('notes_box');
    List<NoteModel> allNotes = box.values.toList();
    activeNotes = allNotes
        .where((note) => note.type == NoteType.ACTIVE)
        .toList();
    archiveNotes = allNotes
        .where((note) => note.type == NoteType.ARCHIVED)
        .toList();
    trashNotes = allNotes
        .where((note) => note.type == NoteType.DELETED)
        .toList();

    emit(
      NotesSuccess(
        activeNotes: activeNotes,
        archiveNotes: archiveNotes,
        trashNotes: trashNotes,
      ),
    );
  }

  void saveOrUpdateNote(NoteModel note) {
    var box = Hive.box<NoteModel>('notes_box');

    box.put(note.id, note);
  }

  void emptyTrash() {
    var box = Hive.box<NoteModel>('notes_box');
    var keysToDelete = trashNotes.map((note) => note.id).toList();

    box.deleteAll(keysToDelete);
    trashNotes.clear();
  }

  //edit yousef
  void searchInNotes(String searchText) {
    final filteredActiveNotes = searchNotes(activeNotes, searchText);
    final filteredArchive = searchNotes(archiveNotes, searchText);
    final filteredTrash = searchNotes(trashNotes, searchText);

    emit(
      NotesSuccess(
        activeNotes: filteredActiveNotes,
        archiveNotes: filteredArchive,
        trashNotes: filteredTrash,
      ),
    );
  }

  void addNote(NoteModel note) {
    emit(NotesLoading());

    activeNotes.add(note);
    saveOrUpdateNote(note);

    emit(
      NotesSuccess(
        activeNotes: activeNotes,
        archiveNotes: archiveNotes,
        trashNotes: trashNotes,
      ),
    );
  }

  void updateNote(NoteModel note) {
    emit(NotesLoading());

    int index = activeNotes.indexWhere((element) => element.id == note.id);

    if (index != -1) {
      activeNotes[index] = note;
      saveOrUpdateNote(note);
    }

    emit(
      NotesSuccess(
        activeNotes: activeNotes,
        archiveNotes: archiveNotes,
        trashNotes: trashNotes,
      ),
    );
  }

  void archiveNote(NoteModel note) {
    emit(NotesLoading());

    activeNotes.remove(note);
    archiveNotes.add(note);
    note.type = NoteType.ARCHIVED;

    saveOrUpdateNote(note);

    emit(
      NotesSuccess(
        activeNotes: activeNotes,
        archiveNotes: archiveNotes,
        trashNotes: trashNotes,
      ),
    );
  }

  void trashNote(NoteModel note, String type) {
    emit(NotesLoading());

    if (type == 'active') {
      activeNotes.remove(note);
    } else if (type == 'archive') {
      archiveNotes.remove(note);
    }

    trashNotes.add(note);

    note.type = NoteType.DELETED;

    saveOrUpdateNote(note);

    emit(
      NotesSuccess(
        activeNotes: activeNotes,
        archiveNotes: archiveNotes,
        trashNotes: trashNotes,
      ),
    );
  }

  void restoreNote(NoteModel note, String type) {
    emit(NotesLoading());

    if (type == 'archive') {
      archiveNotes.remove(note);
    } else if (type == 'trash') {
      trashNotes.remove(note);
    }

    activeNotes.add(note);

    note.type = NoteType.ACTIVE;

    saveOrUpdateNote(note);

    emit(
      NotesSuccess(
        activeNotes: activeNotes,
        archiveNotes: archiveNotes,
        trashNotes: trashNotes,
      ),
    );
  }

  void clearTrash() {
    emit(NotesLoading());

    emptyTrash();

    emit(
      NotesSuccess(
        activeNotes: activeNotes,
        archiveNotes: archiveNotes,
        trashNotes: trashNotes,
      ),
    );
  }
}
