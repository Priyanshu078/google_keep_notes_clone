import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/api/api_service.dart';
import 'package:notes_app/data/note.dart';

import 'notes_event.dart';
import 'notes_states.dart';

class NotesBloc extends Bloc<NotesEvent, NotesStates> {
  NotesBloc()
      : super(const NotesLoading(
          pinnedNotes: [],
          otherNotes: [],
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
    on<TrashNote>((event, emit) => trashNotes(event, emit));
    on<EmptyTrashEvent>((event, emit) => emptyTrash(event, emit));
    on<ArchiveSearchClickedEvent>(((event, emit) => emit(NotesStates(
          pinnedNotes: state.pinnedNotes,
          otherNotes: state.otherNotes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          notesSelected: state.notesSelected,
          archiveSelected: state.archiveSelected,
          trashSelected: state.trashSelected,
          trashNotes: state.trashNotes,
          archivedNotes: state.archivedNotes,
          archiveSearchOn: event.archiveSearchOn,
        ))));
    on<DeleteNote>((event, emit) => deleteNotes(event, emit));
  }
  final ApiService _apiService = ApiService();

  Future<void> deleteNotes(DeleteNote event, Emitter emit) async {
    await _apiService.deleteNotes(event.note);
    List<Note> trashNotes = List.from(state.trashNotes);
    int index = trashNotes.indexWhere((element) => element.id == event.note.id);
    trashNotes.removeAt(index);
    emit(NotesDeleted(
        pinnedNotes: state.pinnedNotes,
        otherNotes: state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn));
  }

  Future<void> emptyTrash(EmptyTrashEvent event, Emitter emit) async {
    await _apiService.emptyTrash();
    List<Note> trashNotes = [];
    emit(NotesStates(
      pinnedNotes: state.pinnedNotes,
      otherNotes: state.otherNotes,
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
      pinnedNotes: state.pinnedNotes,
      otherNotes: state.otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      notesSelected: event.notes,
      archiveSelected: event.archivedNotes,
      trashSelected: event.trashedNotes,
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
    ));
    Map<String, List<Note>> data = await _apiService.getNotes(
        userId: event.userId,
        trashed: event.trashedNotes,
        archived: event.archivedNotes);
    if (event.notes) {
      List<Note> pinnedNotes = [];
      List<Note> otherNotes = [];
      pinnedNotes = sortNotes(data['pinned']!);
      otherNotes = sortNotes(data["others"]!);
      emit(NotesStates(
        pinnedNotes: pinnedNotes,
        otherNotes: otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: event.notes,
        archiveSelected: event.archivedNotes,
        trashSelected: event.trashedNotes,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
      ));
    } else {
      List<Note> notes = data['notes']!;
      notes = sortNotes(notes);
      emit(NotesStates(
        pinnedNotes: state.pinnedNotes,
        otherNotes: state.otherNotes,
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
  }

  List<Note> sortNotes(List<Note> notes) {
    notes.sort((a, b) {
      return DateTime.parse(b.dateAdded).compareTo(DateTime.parse(b.dateAdded));
    });
    return notes;
  }

  Future<void> addNotes(AddNote event, Emitter emit) async {
    await _apiService.addNotes(event.note);
    List<Note> notes = event.note.pinned
        ? List.from(state.pinnedNotes)
        : List.from(state.otherNotes);
    notes.add(event.note);
    notes = sortNotes(notes);
    emit(NotesStates(
      pinnedNotes: event.note.pinned ? notes : state.pinnedNotes,
      otherNotes: !event.note.pinned ? notes : state.otherNotes,
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
    if (event.fromTrash) {
      List<Note> trashNotes = List.from(state.trashNotes);
      int index =
          trashNotes.indexWhere((element) => element.id == event.note.id);
      Note note = trashNotes[index];
      trashNotes.removeAt(index);
      List<Note> otherNotes = state.otherNotes;
      otherNotes.add(note);
      trashNotes = sortNotes(trashNotes);
      otherNotes = sortNotes(otherNotes);
      emit(NotesRestored(
        pinnedNotes: state.pinnedNotes,
        otherNotes: otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
      ));
    } else if (event.forArchive) {
      List<Note> notes = event.note.pinned
          ? List.from(state.pinnedNotes)
          : List.from(state.otherNotes);
      int index = notes.indexWhere((element) => element.id == event.note.id);
      Note note = event.note.copyWith(pinned: false);
      notes.removeAt(index);
      notes = sortNotes(notes);
      List<Note> archivedNotes = List.from(state.archivedNotes);
      archivedNotes.add(note);
      archivedNotes = sortNotes(archivedNotes);
      emit(NotesArchived(
        pinnedNotes: event.note.pinned ? notes : state.pinnedNotes,
        otherNotes: !event.note.pinned ? notes : state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
      ));
    } else if (event.forUnArchive) {
      List<Note> notes = List.from(state.archivedNotes);
      int index = notes.indexWhere((element) => element.id == event.note.id);
      Note note = notes[index];
      notes.removeAt(index);
      notes = sortNotes(notes);
      List<Note> otherNotes = event.pinnedUnarchive
          ? List.from(state.pinnedNotes)
          : List.from(state.otherNotes);
      otherNotes.add(note);
      otherNotes = sortNotes(otherNotes);
      emit(NotesUnarchived(
          pinnedNotes: event.pinnedUnarchive ? otherNotes : state.pinnedNotes,
          otherNotes: !event.pinnedUnarchive ? otherNotes : state.otherNotes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          notesSelected: state.notesSelected,
          archiveSelected: state.archiveSelected,
          trashSelected: state.trashSelected,
          trashNotes: state.trashNotes,
          archivedNotes: notes,
          archiveSearchOn: state.archiveSearchOn));
    } else {
      List<Note> notes = event.fromArchive
          ? List.from(state.archivedNotes)
          : event.note.pinned
              ? List.from(state.pinnedNotes)
              : List.from(state.otherNotes);
      int index = notes.indexWhere((note) => note.id == event.note.id);
      notes[index] = event.note;
      notes = sortNotes(notes);
      emit(NotesStates(
        pinnedNotes: event.note.pinned ? notes : state.pinnedNotes,
        otherNotes: !event.note.pinned ? notes : state.otherNotes,
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

  void changeView(ChangeViewEvent event, Emitter emit) {
    emit(NotesStates(
      pinnedNotes: state.pinnedNotes,
      otherNotes: state.otherNotes,
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

  Future<void> trashNotes(TrashNote event, Emitter emit) async {
    await _apiService.trashNotes(event.note);
    List<Note> notes = event.note.pinned
        ? List.from(state.pinnedNotes)
        : List.from(state.otherNotes);
    int index = notes.indexWhere((element) => element.id == event.note.id);
    List<Note> trashedNotes = List.from(state.trashNotes);
    trashedNotes.add(
        notes[index].copyWith(dateAdded: DateTime.now().toIso8601String()));
    trashedNotes = sortNotes(trashedNotes);
    notes.removeAt(index);
    notes = sortNotes(notes);
    if (event.addNotesPage) {
      emit(NotesTrashed(
        pinnedNotes: event.note.pinned ? notes : state.pinnedNotes,
        otherNotes: !event.note.pinned ? notes : state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: trashedNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
      ));
    } else {
      emit(NotesStates(
        pinnedNotes: event.note.pinned ? notes : state.pinnedNotes,
        otherNotes: !event.note.pinned ? notes : state.otherNotes,
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
