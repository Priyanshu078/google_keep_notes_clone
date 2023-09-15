import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/api/api_service.dart';
import 'package:notes_app/data/note.dart';

import 'notes_event.dart';
import 'notes_states.dart';

class NotesBloc extends Bloc<NotesEvent, NotesStates> {
  NotesBloc() : super(const NotesLoading(notes: [])) {
    on<FetchNotes>((event, emit) => fetchNotes(event, emit));
    on<AddNote>((event, emit) => addNotes(event, emit));
  }
  final ApiService _apiService = ApiService();

  Future<void> fetchNotes(FetchNotes event, Emitter emit) async {
    emit(const NotesLoading(notes: []));
    List<Note> notes = [];
    notes = await _apiService.getNotes(event.userId);
    notes = sortNotes(notes);
    emit(NotesStates(notes: notes));
  }

  List<Note> sortNotes(List<Note> notes) {
    notes.sort((a, b) =>
        DateTime.parse(b.dateAdded).compareTo(DateTime.parse(a.dateAdded)));
    return notes;
  }

  Future<void> addNotes(AddNote event, Emitter emit) async {
    await _apiService.addNotes(event.note);
    List<Note> notes = List.from(state.notes);
    notes.add(event.note);
    notes = sortNotes(notes);
    emit(NotesStates(notes: notes));
  }
}
