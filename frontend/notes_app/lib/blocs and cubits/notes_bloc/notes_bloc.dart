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
          trashNotes: [],
          archivedNotes: [],
          archiveSearchOn: false,
        )) {
    on<FetchNotes>((event, emit) => fetchNotes(event, emit));
    on<AddNote>((event, emit) => addNotes(event, emit));
    on<UpdateNote>((event, emit) => updateNotes(event, emit));
    on<ChangeViewEvent>((event, emit) => changeView(event, emit));
    on<DeleteNote>((event, emit) => deleteNotes(event, emit));
    on<EmptyTrashEvent>((event, emit) => emptyTrash(event, emit));
    on<ArchiveSearchClickedEvent>(((event, emit) => emit(NotesStates(
          notes: state.notes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          notesSelected: state.notesSelected,
          archiveSelected: state.archiveSelected,
          trashSelected: state.trashSelected,
          trashNotes: state.trashNotes,
          archivedNotes: state.archivedNotes,
          archiveSearchOn: event.archiveSearchOn,
        ))));
  }
  final ApiService _apiService = ApiService();

  Future<void> emptyTrash(EmptyTrashEvent event, Emitter emit) async {
    await _apiService.emptyTrash();
    List<Note> trashNotes = [];
    emit(NotesStates(
      notes: state.notes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: state.notesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
    ));
  }

  Future<void> fetchNotes(FetchNotes event, Emitter emit) async {
    emit(NotesLoading(
      notes: state.notes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: event.notes,
      archiveSelected: event.archivedNotes,
      trashSelected: event.trashedNotes,
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
    ));
    List<Note> notes = [];
    notes = await _apiService.getNotes(
        userId: event.userId,
        trashed: event.trashedNotes,
        archived: event.archivedNotes);
    notes = sortNotes(notes);
    emit(NotesStates(
      notes: event.notes ? notes : state.notes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: event.notes,
      archiveSelected: event.archivedNotes,
      trashSelected: event.trashedNotes,
      trashNotes: event.trashedNotes ? notes : state.trashNotes,
      archivedNotes: event.archivedNotes ? notes : state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
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
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
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
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
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
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
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
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
      ));
    } else {
      emit(NotesStates(
        notes: notes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
      ));
    }
  }
}
