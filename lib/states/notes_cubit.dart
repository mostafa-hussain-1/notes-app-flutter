import 'package:flutter_bloc/flutter_bloc.dart';
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
    
    // load data base
    String content = 'erk;gjbrg';
    String title = 'erk';
    NoteModel note = NoteModel(title: title, content: content);
    activeNotes.add(note);
    content = 'erk;gjbrg';
    title = 'mostafa';
    note = NoteModel(title: title, content: content);
    activeNotes.add(note);
    content = 'erk;gjbrg';
    title = 'elsayed';
    note = NoteModel(title: title, content: content);
    activeNotes.add(note);
    content = 'erk;gjbrg';
    title = 'bigoo';
    note = NoteModel(title: title, content: content);
    activeNotes.add(note);
    content = 'erk;gjbrg';
    title = 'sama';
    note = NoteModel(title: title, content: content);
    archiveNotes.add(note);
    content = 'erk;gjbrg';
    title = 'tifa';
    note = NoteModel(title: title, content: content);
    archiveNotes.add(note);
    content = 'erk;gjbrg';
    title = 'erk';
    note = NoteModel(title: title, content: content);
    archiveNotes.add(note);
    content = 'erk;gjbrg';
    title = 'erk';
    note = NoteModel(title: title, content: content);
    trashNotes.add(note);
    content = 'al';
    title = 'you';
    note = NoteModel(title: title, content: content);
    trashNotes.add(note);
    content = 'al';
    title = 'me';
    note = NoteModel(title: title, content: content);
    trashNotes.add(note);
    content = 'al';
    title = 'she';
    note = NoteModel(title: title, content: content);
    trashNotes.add(note);
    content = 'al';
    title = 'he';
    note = NoteModel(title: title, content: content);
    trashNotes.add(note);
    
    // load data base

    emit(NotesSuccess(activeNotes: activeNotes, archiveNotes: archiveNotes, trashNotes: trashNotes));
  }

  //edit yousef
  void searchInNotes(String searchText) 
  {
    final filteredActiveNotes = searchNotes(activeNotes, searchText);
    final filteredArchive = searchNotes(archiveNotes, searchText);
    final filteredTrash = searchNotes(trashNotes, searchText);

    emit(NotesSuccess(
      activeNotes: filteredActiveNotes, 
      archiveNotes: filteredArchive, 
      trashNotes: filteredTrash,
    ));
  }

  


  void addNote(NoteModel note) {
    emit(NotesLoading()); 

    activeNotes.add(note);
    
    emit(NotesSuccess(
      activeNotes: activeNotes, 
      archiveNotes: archiveNotes, 
      trashNotes: trashNotes
    ));
  }

  void archiveNote(NoteModel note) {
    emit(NotesLoading());
  
    activeNotes.remove(note);
    archiveNotes.add(note);
  
    emit(NotesSuccess(
      activeNotes: activeNotes,
      archiveNotes: archiveNotes,
      trashNotes: trashNotes,
    ));
  }
  
  void trashNote(NoteModel note, String type) {
    emit(NotesLoading());
  
    if (type == 'active') {
      activeNotes.remove(note);
    } else if (type == 'archive') {
      archiveNotes.remove(note);
    }
  
    trashNotes.add(note);
  
    emit(NotesSuccess(
      activeNotes: activeNotes,
      archiveNotes: archiveNotes,
      trashNotes: trashNotes,
    ));
  }
  
  void restoreNote(NoteModel note, String type) {
    emit(NotesLoading());
  
    if (type == 'archive') {
      archiveNotes.remove(note);
    } else if (type == 'trash') {
      trashNotes.remove(note);
    }
  
    activeNotes.add(note);
  
    emit(NotesSuccess(
      activeNotes: activeNotes,
      archiveNotes: archiveNotes,
      trashNotes: trashNotes,
    ));
  }

  void clearTrash()
  {
    emit(NotesLoading());   //Useful when in use database

    trashNotes.clear();

    emit(NotesSuccess
      (
      activeNotes: activeNotes,
      archiveNotes: archiveNotes,
      trashNotes: trashNotes,
      )
    );
  }


  
}