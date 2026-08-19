import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/states/notes_states.dart';


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
    title = 'erk';
    note = NoteModel(title: title, content: content);
    activeNotes.add(note);
    content = 'erk;gjbrg';
    title = 'erk';
    note = NoteModel(title: title, content: content);
    activeNotes.add(note);
    content = 'erk;gjbrg';
    title = 'erk';
    note = NoteModel(title: title, content: content);
    activeNotes.add(note);
    content = 'erk;gjbrg';
    title = 'erk';
    note = NoteModel(title: title, content: content);
    archiveNotes.add(note);
    content = 'erk;gjbrg';
    title = 'erk';
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
    content = 'erk;gjbrg';
    title = 'erk';
    note = NoteModel(title: title, content: content);
    trashNotes.add(note);
    
    // load data base

    emit(NotesSuccess(activeNotes: activeNotes, archiveNotes: archiveNotes, trashNotes: trashNotes));
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

  
}