import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/api/api_service.dart';
import 'package:notes_app/data/note.dart';

import 'notes_event.dart';
import 'notes_states.dart';

class NotesBloc extends Bloc<NotesEvent, NotesStates> {
  NotesBloc()
      : super(const NotesLoading(
          notes: [],
          gridViewMode: true,
          lightMode: true,
          notesSelected: true,
          archiveSelected: false,
          trashSelected: false,
        )) {
    on<FetchNotes>((event, emit) => fetchNotes(event, emit));
    on<AddNote>((event, emit) => addNotes(event, emit));
    on<UpdateNote>((event, emit) => updateNotes(event, emit));
    on<ChangeViewEvent>((event, emit) => changeView(event, emit));
    on<DeleteNote>((event, emit) => deleteNotes(event, emit));
    on<NotesSelectEvent>((event, emit) => emit(NotesStates(
          notes: state.notes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          notesSelected: true,
          archiveSelected: false,
          trashSelected: false,
        )));
    on<ArchiveSelectEvent>((event, emit) => emit(NotesStates(
          notes: state.notes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          notesSelected: false,
          archiveSelected: true,
          trashSelected: false,
        )));
    on<TrashSelectEvent>((event, emit) => emit(NotesStates(
          notes: state.notes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          notesSelected: false,
          archiveSelected: false,
          trashSelected: true,
        )));
  }
  final ApiService _apiService = ApiService();

  Future<void> fetchNotes(FetchNotes event, Emitter emit) async {
    emit(const NotesLoading(
      notes: [],
      gridViewMode: true,
      lightMode: true,
      notesSelected: true,
      archiveSelected: false,
      trashSelected: false,
    ));
    List<Note> notes = [];
    notes = await _apiService.getNotes(
        userId: event.userId, trashed: false, archived: false);
    notes = sortNotes(notes);
    emit(NotesStates(
      notes: notes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: state.notesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
    ));
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
    emit(NotesStates(
      notes: notes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: state.notesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
    ));
  }

  Future<void> updateNotes(UpdateNote event, Emitter emit) async {
    await _apiService.updateNotes(event.note);
    List<Note> notes = List.from(state.notes);
    int index = notes.indexWhere((note) => note.id == event.note.id);
    notes[index] = event.note;
    notes = sortNotes(notes);
    emit(NotesStates(
      notes: notes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: state.notesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
    ));
  }

  void changeView(ChangeViewEvent event, Emitter emit) {
    emit(NotesStates(
      notes: state.notes,
      gridViewMode: !state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: state.notesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
    ));
  }

  Future<void> deleteNotes(DeleteNote event, Emitter emit) async {
    await _apiService.deleteNotes(event.note);
    List<Note> notes = List.from(state.notes);
    int index = notes.indexWhere((element) => element.id == event.note.id);
    notes.removeAt(index);
    notes = sortNotes(notes);
    if (event.addNotesPage) {
      emit(NotesDeleted(
        notes: notes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
      ));
    } else {
      emit(NotesStates(
        notes: notes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
      ));
    }
  }
}
