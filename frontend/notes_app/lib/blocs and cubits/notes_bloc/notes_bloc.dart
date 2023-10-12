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
          homeSearchOn: false,
        )) {
    on<FetchNotes>((event, emit) => fetchNotes(event, emit));
    on<AddNote>((event, emit) => addNotes(event, emit));
    on<UpdateNote>((event, emit) => updateNotes(event, emit));
    on<ChangeViewEvent>((event, emit) => changeView(event, emit));
    on<TrashNote>((event, emit) => trashNotes(event, emit));
    on<EmptyTrashEvent>((event, emit) => emptyTrash(event, emit));
    on<DeleteNote>((event, emit) => deleteNotes(event, emit));
    on<PinNoteEvent>((event, emit) => pinNotes(event, emit));
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
          homeSearchOn: state.homeSearchOn,
        ))));
    on<HomeSearchClickedEvent>((event, emit) => emit(NotesStates(
          pinnedNotes: state.pinnedNotes,
          otherNotes: state.otherNotes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          notesSelected: state.notesSelected,
          archiveSelected: state.archiveSelected,
          trashSelected: state.trashSelected,
          trashNotes: state.trashNotes,
          archivedNotes: state.archivedNotes,
          archiveSearchOn: state.archiveSearchOn,
          homeSearchOn: event.homeSearchOn,
        )));
  }
  final ApiService _apiService = ApiService();

  Future<void> pinNotes(PinNoteEvent event, Emitter emit) async {
    await _apiService.updateNotes(event.note);
    List<Note> pinnedNotes = List.from(state.pinnedNotes);
    List<Note> otherNotes = List.from(state.otherNotes);
    if (event.note.pinned) {
      int index =
          otherNotes.indexWhere((element) => element.id == event.note.id);
      otherNotes.removeAt(index);
      pinnedNotes.add(event.note);
      pinnedNotes = sortNotes(pinnedNotes);
    } else {
      int index =
          pinnedNotes.indexWhere((element) => element.id == event.note.id);
      pinnedNotes.removeAt(index);
      otherNotes.add(event.note);
      otherNotes = sortNotes(otherNotes);
    }
    emit(NotesStates(
        pinnedNotes: pinnedNotes,
        otherNotes: otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn));
  }

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
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
    ));
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
      homeSearchOn: state.homeSearchOn,
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
      homeSearchOn: state.homeSearchOn,
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
        homeSearchOn: state.homeSearchOn,
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
        homeSearchOn: state.homeSearchOn,
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
      homeSearchOn: state.homeSearchOn,
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
        homeSearchOn: state.homeSearchOn,
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
        homeSearchOn: state.homeSearchOn,
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
      emit(event.pinnedUnarchive
          ? NotesPinnedUnarchived(
              pinnedNotes:
                  event.pinnedUnarchive ? otherNotes : state.pinnedNotes,
              otherNotes:
                  !event.pinnedUnarchive ? otherNotes : state.otherNotes,
              gridViewMode: state.gridViewMode,
              lightMode: state.lightMode,
              notesSelected: state.notesSelected,
              archiveSelected: state.archiveSelected,
              trashSelected: state.trashSelected,
              trashNotes: state.trashNotes,
              archivedNotes: notes,
              archiveSearchOn: state.archiveSearchOn,
              homeSearchOn: state.homeSearchOn,
            )
          : NotesUnarchived(
              pinnedNotes:
                  event.pinnedUnarchive ? otherNotes : state.pinnedNotes,
              otherNotes:
                  !event.pinnedUnarchive ? otherNotes : state.otherNotes,
              gridViewMode: state.gridViewMode,
              lightMode: state.lightMode,
              notesSelected: state.notesSelected,
              archiveSelected: state.archiveSelected,
              trashSelected: state.trashSelected,
              trashNotes: state.trashNotes,
              archivedNotes: notes,
              archiveSearchOn: state.archiveSearchOn,
              homeSearchOn: state.homeSearchOn,
            ));
    } else if (event.fromArchive) {
      List<Note> notes = List.from(state.archivedNotes);
      // : event.homeNotePinned
      //     ? List.from(state.pinnedNotes)
      //     : List.from(state.otherNotes);
      int index = notes.indexWhere((note) => note.id == event.note.id);
      notes[index] = event.note;
      notes = sortNotes(notes);
      emit(NotesStates(
        pinnedNotes: state.pinnedNotes,
        // : event.homeNotePinned
        //     ? notes
        //     : state.pinnedNotes,
        otherNotes: state.otherNotes,
        // : !event.homeNotePinned
        //     ? notes
        //     : state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: notes,
        // : state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
      ));
    } else {
      List<Note> pinnedNotes = List.from(state.pinnedNotes);
      List<Note> otherNotes = List.from(state.otherNotes);
      if (event.homeNotePinned) {
        if (event.note.pinned) {
          int index =
              pinnedNotes.indexWhere((element) => element.id == event.note.id);
          pinnedNotes[index] = event.note;
          pinnedNotes = sortNotes(pinnedNotes);
        } else {
          int index =
              pinnedNotes.indexWhere((element) => element.id == event.note.id);
          pinnedNotes.removeAt(index);
          otherNotes.add(event.note);
          otherNotes = sortNotes(otherNotes);
        }
      } else {
        if (event.note.pinned) {
          int index =
              otherNotes.indexWhere((element) => element.id == event.note.id);
          otherNotes.removeAt(index);
          pinnedNotes.add(event.note);
          pinnedNotes = sortNotes(pinnedNotes);
        } else {
          int index =
              otherNotes.indexWhere((element) => element.id == event.note.id);
          otherNotes[index] = event.note;
          otherNotes = sortNotes(otherNotes);
        }
      }
      emit(NotesStates(
        pinnedNotes: pinnedNotes,
        otherNotes: otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        notesSelected: state.notesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
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
      homeSearchOn: state.homeSearchOn,
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
        homeSearchOn: state.homeSearchOn,
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
        homeSearchOn: state.homeSearchOn,
      ));
    }
  }
}
