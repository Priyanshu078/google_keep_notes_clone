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
          homeNotesSelected: true,
          archiveSelected: false,
          trashSelected: false,
          trashNotes: [],
          archivedNotes: [],
          archiveSearchOn: false,
          homeSearchOn: false,
          selectedNotes: [],
          pinSelectedNotes: false,
          selectedPinnedNotes: [],
          selectedOtherNotes: [],
        )) {
    on<FetchNotes>((event, emit) => fetchNotes(event, emit));
    on<AddNote>((event, emit) => addNotes(event, emit));
    on<UpdateNote>((event, emit) => updateNotes(event, emit));
    on<ChangeViewEvent>((event, emit) => changeView(event, emit));
    on<TrashNote>((event, emit) => trashNotes(event, emit));
    on<EmptyTrashEvent>((event, emit) => emptyTrash(event, emit));
    on<DeleteNote>((event, emit) => deleteNotes(event, emit));
    on<PinNoteEvent>((event, emit) => pinNotes(event, emit));
    on<SelectNoteEvent>((event, emit) => selectNote(event, emit));
    on<UnselectAllNotesEvent>((event, emit) => unselectAllNotes(event, emit));
    on<RestoreNotes>((event, emit) => restoreNotes(event, emit));
    on<PinUnpinEvent>((event, emit) => pinUnpinNotes(event, emit));
    on<BulkUpdateNotes>((event, emit) => _bulkUpdateColorNotes(event, emit));
    on<BulkArchiveUnarchiveEvent>(
        (event, emit) => _bulkArchiveUnarchiveNotes(event, emit));
    on<BulkTrashEvent>((event, emit) => _bulkTrashNotes(event, emit));
    on<ArchiveSearchClickedEvent>(((event, emit) => emit(NotesStates(
          pinnedNotes: state.pinnedNotes,
          otherNotes: state.otherNotes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          homeNotesSelected: state.homeNotesSelected,
          archiveSelected: state.archiveSelected,
          trashSelected: state.trashSelected,
          trashNotes: state.trashNotes,
          archivedNotes: state.archivedNotes,
          archiveSearchOn: event.archiveSearchOn,
          homeSearchOn: state.homeSearchOn,
          selectedNotes: state.selectedNotes,
          pinSelectedNotes: false,
          selectedPinnedNotes: const [],
          selectedOtherNotes: const [],
        ))));
    on<HomeSearchClickedEvent>((event, emit) => emit(NotesStates(
          pinnedNotes: state.pinnedNotes,
          otherNotes: state.otherNotes,
          gridViewMode: state.gridViewMode,
          lightMode: state.lightMode,
          homeNotesSelected: state.homeNotesSelected,
          archiveSelected: state.archiveSelected,
          trashSelected: state.trashSelected,
          trashNotes: state.trashNotes,
          archivedNotes: state.archivedNotes,
          archiveSearchOn: state.archiveSearchOn,
          homeSearchOn: event.homeSearchOn,
          selectedNotes: state.selectedNotes,
          pinSelectedNotes: false,
          selectedPinnedNotes: const [],
          selectedOtherNotes: const [],
        )));
  }
  final ApiService _apiService = ApiService();

  Future<void> _bulkTrashNotes(BulkTrashEvent event, Emitter emit) async {
    List<Note> notesList = List.from(event.notesList);
    List<Note> pinnedNotes = List.from(state.pinnedNotes);
    List<Note> otherNotes = List.from(state.otherNotes);
    List<Note> trashNotes = List.from(state.trashNotes);
    List<Note> archivedNotes = List.from(state.archivedNotes);
    for (int i = 0; i < notesList.length; i++) {
      if (state.homeNotesSelected) {
        if (notesList[i].pinned) {
          int index = pinnedNotes
              .indexWhere((element) => element.id == notesList[i].id);
          pinnedNotes.removeAt(index);
        } else {
          int index =
              otherNotes.indexWhere((element) => element.id == notesList[i].id);
          otherNotes.removeAt(index);
        }
      } else if (state.archiveSelected) {
        int index = archivedNotes
            .indexWhere((element) => element.id == notesList[i].id);
        archivedNotes.removeAt(index);
      }
      Note note = notesList[i].copyWith(
        dateAdded: DateTime.now().toIso8601String(),
        pinned: false,
        archived: false,
        trashed: true,
        selected: false,
      );
      trashNotes.add(note);
      trashNotes = sortNotes(trashNotes);
      notesList[i] = note;
    }
    await _apiService.bulkUpdateNotes(notesList);
    emit(NotesStates(
      pinnedNotes: pinnedNotes,
      otherNotes: otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: trashNotes,
      archivedNotes: archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: const [],
      pinSelectedNotes: false,
      selectedOtherNotes: const [],
      selectedPinnedNotes: const [],
    ));
  }

  Future<void> _bulkArchiveUnarchiveNotes(
      BulkArchiveUnarchiveEvent event, Emitter emit) async {
    List<Note> notesList = List.from(event.notesList);
    List<Note> pinnedNotes = List.from(state.pinnedNotes);
    List<Note> otherNotes = List.from(state.otherNotes);
    List<Note> archivedNotes = List.from(state.archivedNotes);
    for (int i = 0; i < notesList.length; i++) {
      if (event.archive) {
        if (notesList[i].pinned) {
          int index = pinnedNotes
              .indexWhere((element) => element.id == notesList[i].id);
          pinnedNotes.removeAt(index);
        } else {
          int index =
              otherNotes.indexWhere((element) => element.id == notesList[i].id);
          otherNotes.removeAt(index);
        }
        Note note = notesList[i].copyWith(
            archived: true,
            selected: false,
            pinned: false,
            trashed: false,
            dateAdded: DateTime.now().toIso8601String());
        notesList[i] = note;
        archivedNotes.add(note);
      } else {
        Note note = notesList[i].copyWith(
          dateAdded: DateTime.now().toIso8601String(),
          pinned: false,
          selected: false,
          archived: false,
          trashed: false,
        );
        notesList[i] = note;
        otherNotes.add(note);
        int index =
            archivedNotes.indexWhere((element) => element.id == note.id);
        archivedNotes.removeAt(index);
      }
    }
    if (event.archive) {
      archivedNotes = sortNotes(archivedNotes);
    } else {
      otherNotes = sortNotes(otherNotes);
    }
    await _apiService.bulkUpdateNotes(notesList);
    emit(NotesStates(
      pinnedNotes: pinnedNotes,
      otherNotes: otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: state.trashNotes,
      archivedNotes: archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: const [],
      pinSelectedNotes: false,
      selectedOtherNotes: const [],
      selectedPinnedNotes: const [],
    ));
  }

  Future<void> restoreNotes(RestoreNotes event, Emitter emit) async {
    await _apiService.restoreNotes(event.notesList);
    List<Note> trashNotes = List.from(state.trashNotes);
    List<Note> otherNotes = List.from(state.otherNotes);
    List<Note> selectedNotes = event.notesList;
    for (int i = 0; i < selectedNotes.length; i++) {
      int trashNotesIndex =
          trashNotes.indexWhere((element) => element.id == selectedNotes[i].id);
      trashNotes.removeAt(trashNotesIndex);
      Note note = selectedNotes[i].copyWith(
        dateAdded: DateTime.now().toIso8601String(),
        pinned: false,
        archived: false,
        trashed: false,
        selected: false,
      );
      otherNotes.add(note);
    }
    otherNotes = sortNotes(otherNotes);
    emit(NotesRestored(
      pinnedNotes: state.pinnedNotes,
      otherNotes: otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: const [],
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
    ));
  }

  Future<void> unselectAllNotes(
      UnselectAllNotesEvent event, Emitter emit) async {
    List<Note> pinnednotes = List.from(state.pinnedNotes);
    List<Note> otherNotes = List.from(state.otherNotes);
    List<Note> archivedNotes = List.from(state.archivedNotes);
    List<Note> trashNotes = List.from(state.trashNotes);
    if (event.homeNotesSelected) {
      for (int i = 0; i < pinnednotes.length; i++) {
        if (pinnednotes[i].selected) {
          pinnednotes[i] = pinnednotes[i].copyWith(selected: false);
        }
      }
      for (int i = 0; i < otherNotes.length; i++) {
        if (otherNotes[i].selected) {
          otherNotes[i] = otherNotes[i].copyWith(selected: false);
        }
      }
    } else if (event.archivedSelected) {
      for (int i = 0; i < archivedNotes.length; i++) {
        if (archivedNotes[i].selected) {
          archivedNotes[i] = archivedNotes[i].copyWith(selected: false);
        }
      }
    } else if (event.trashSelected) {
      for (int i = 0; i < trashNotes.length; i++) {
        if (trashNotes[i].selected) {
          trashNotes[i] = trashNotes[i].copyWith(selected: false);
        }
      }
    }
    emit(NotesStates(
      pinnedNotes: event.homeNotesSelected ? pinnednotes : state.pinnedNotes,
      otherNotes: event.homeNotesSelected ? otherNotes : state.otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: event.trashSelected ? trashNotes : state.trashNotes,
      archivedNotes:
          event.archivedSelected ? archivedNotes : state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: const [],
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
    ));
  }

  Future<void> selectNote(SelectNoteEvent event, Emitter emit) async {
    List<Note> notes = List.from(event.homeNotes
        ? event.note.pinned
            ? state.pinnedNotes
            : state.otherNotes
        : event.archivedNotes
            ? state.archivedNotes
            : state.trashNotes);
    List<Note> selectedNotes = List.from(state.selectedNotes);
    List<Note> selectedPinnedNotes = List.from(state.selectedPinnedNotes);
    List<Note> selectedOtherNotes = List.from(state.selectedOtherNotes);
    // index of selected note from selected notes list
    int selectedNoteIndex =
        selectedNotes.indexWhere((element) => element.id == event.note.id);
    // index of actual notes which is being selected now
    int index = notes.indexWhere((element) => element.id == event.note.id);

    if (selectedNoteIndex != -1) {
      selectedNotes.removeAt(selectedNoteIndex);
      notes[index] = event.note.copyWith(selected: false);
      if (state.homeNotesSelected) {
        if (event.note.pinned) {
          int selectedPinnedNoteIndex = selectedPinnedNotes
              .indexWhere((element) => element.id == event.note.id);
          selectedPinnedNotes.removeAt(selectedPinnedNoteIndex);
        } else {
          int selectedPinnedNoteIndex = selectedOtherNotes
              .indexWhere((element) => element.id == event.note.id);
          selectedOtherNotes.removeAt(selectedPinnedNoteIndex);
        }
      }
    } else {
      Note note = event.note.copyWith(selected: true);
      selectedNotes.add(note);
      notes[index] = note;
      if (state.homeNotesSelected) {
        if (note.pinned) {
          selectedPinnedNotes.add(note);
        } else {
          selectedOtherNotes.add(note);
        }
      }
    }

    // case1 when all selected notes are pinned then we will unpin all of these notes.
    // case2 when all selected notes are unpinnede then we will pinn these notes.
    // case3 when some are pinned and some are unpinned these notes will be pinned.
    bool pinStatus = state.pinSelectedNotes;

    if (selectedPinnedNotes.isEmpty) {
      pinStatus = false;
    } else if (selectedOtherNotes.isEmpty) {
      pinStatus = true;
    } else {
      pinStatus = false;
    }

    if (selectedNotes.isEmpty) {
      emit(NotesStates(
        pinnedNotes:
            (event.homeNotes && event.note.pinned) ? notes : state.pinnedNotes,
        otherNotes:
            (event.homeNotes && !event.note.pinned) ? notes : state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: event.trashNotes ? notes : state.trashNotes,
        archivedNotes: event.archivedNotes ? notes : state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
      ));
    } else {
      emit(NotesSelected(
        pinnedNotes:
            (event.homeNotes && event.note.pinned) ? notes : state.pinnedNotes,
        otherNotes:
            (event.homeNotes && !event.note.pinned) ? notes : state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: event.trashNotes ? notes : state.trashNotes,
        archivedNotes: event.archivedNotes ? notes : state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: selectedNotes,
        pinSelectedNotes: pinStatus,
        selectedPinnedNotes: (state.archiveSelected || state.trashSelected)
            ? []
            : selectedPinnedNotes,
        selectedOtherNotes: (state.archiveSelected || state.trashSelected)
            ? []
            : selectedOtherNotes,
      ));
    }
  }

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
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: state.selectedNotes,
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
    ));
  }

  Future<void> deleteNotes(DeleteNote event, Emitter emit) async {
    await _apiService.deleteNotes(event.noteslist);
    List<Note> trashNotes = List.from(state.trashNotes);
    for (int i = 0; i < event.noteslist.length; i++) {
      int index = trashNotes
          .indexWhere((element) => element.id == event.noteslist[i].id);
      trashNotes.removeAt(index);
    }
    emit(NotesDeleted(
      pinnedNotes: state.pinnedNotes,
      otherNotes: state.otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: event.fromSelectedNotes ? [] : state.selectedNotes,
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
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
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: state.selectedNotes,
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
    ));
  }

  Future<void> fetchNotes(FetchNotes event, Emitter emit) async {
    emit(NotesLoading(
      pinnedNotes: state.pinnedNotes,
      otherNotes: state.otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: event.notes,
      archiveSelected: event.archivedNotes,
      trashSelected: event.trashedNotes,
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: state.selectedNotes,
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
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
        homeNotesSelected: event.notes,
        archiveSelected: event.archivedNotes,
        trashSelected: event.trashedNotes,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
      ));
    } else {
      List<Note> notes = data['notes']!;
      notes = sortNotes(notes);
      emit(NotesStates(
        pinnedNotes: state.pinnedNotes,
        otherNotes: state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        homeNotesSelected: event.notes,
        archiveSelected: event.archivedNotes,
        trashSelected: event.trashedNotes,
        trashNotes: event.trashedNotes ? notes : state.trashNotes,
        archivedNotes: event.archivedNotes ? notes : state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
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
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: state.selectedNotes,
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
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
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
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
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
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
              homeNotesSelected: state.homeNotesSelected,
              archiveSelected: state.archiveSelected,
              trashSelected: state.trashSelected,
              trashNotes: state.trashNotes,
              archivedNotes: notes,
              archiveSearchOn: state.archiveSearchOn,
              homeSearchOn: state.homeSearchOn,
              selectedNotes: state.selectedNotes,
              pinSelectedNotes: false,
              selectedPinnedNotes: const [],
              selectedOtherNotes: const [],
            )
          : NotesUnarchived(
              pinnedNotes:
                  event.pinnedUnarchive ? otherNotes : state.pinnedNotes,
              otherNotes:
                  !event.pinnedUnarchive ? otherNotes : state.otherNotes,
              gridViewMode: state.gridViewMode,
              lightMode: state.lightMode,
              homeNotesSelected: state.homeNotesSelected,
              archiveSelected: state.archiveSelected,
              trashSelected: state.trashSelected,
              trashNotes: state.trashNotes,
              archivedNotes: notes,
              archiveSearchOn: state.archiveSearchOn,
              homeSearchOn: state.homeSearchOn,
              selectedNotes: state.selectedNotes,
              pinSelectedNotes: false,
              selectedPinnedNotes: const [],
              selectedOtherNotes: const [],
            ));
    } else if (event.fromArchive) {
      List<Note> notes = List.from(state.archivedNotes);
      int index = notes.indexWhere((note) => note.id == event.note.id);
      notes[index] = event.note;
      notes = sortNotes(notes);
      emit(NotesStates(
        pinnedNotes: state.pinnedNotes,
        otherNotes: state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: notes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
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
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
      ));
    }
  }

  void changeView(ChangeViewEvent event, Emitter emit) {
    emit(NotesStates(
      pinnedNotes: state.pinnedNotes,
      otherNotes: state.otherNotes,
      gridViewMode: !state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: state.trashNotes,
      archivedNotes: state.archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: state.selectedNotes,
      pinSelectedNotes: false,
      selectedPinnedNotes: const [],
      selectedOtherNotes: const [],
    ));
  }

  Future<void> trashNotes(TrashNote event, Emitter emit) async {
    await _apiService.trashNotes(event.note);
    List<Note> notes = event.fromArchive
        ? state.archivedNotes
        : event.note.pinned
            ? List.from(state.pinnedNotes)
            : List.from(state.otherNotes);
    int index = notes.indexWhere((element) => element.id == event.note.id);
    List<Note> trashedNotes = List.from(state.trashNotes);
    Note note = event.note.copyWith(
        trashed: true,
        pinned: false,
        archived: false,
        dateAdded: DateTime.now().toIso8601String());
    trashedNotes.add(note);
    trashedNotes = sortNotes(trashedNotes);
    notes.removeAt(index);
    notes = sortNotes(notes);
    if (event.addNotesPage) {
      emit(NotesTrashed(
        pinnedNotes: event.fromArchive
            ? state.pinnedNotes
            : event.note.pinned
                ? notes
                : state.pinnedNotes,
        otherNotes: event.fromArchive
            ? state.otherNotes
            : !event.note.pinned
                ? notes
                : state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: trashedNotes,
        archivedNotes: event.fromArchive ? notes : state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
      ));
    } else {
      emit(NotesStates(
        pinnedNotes: event.note.pinned ? notes : state.pinnedNotes,
        otherNotes: !event.note.pinned ? notes : state.otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: state.selectedNotes,
        pinSelectedNotes: false,
        selectedPinnedNotes: const [],
        selectedOtherNotes: const [],
      ));
    }
  }

  Future<void> pinUnpinNotes(PinUnpinEvent event, Emitter emit) async {
    List<Note> pinnedNotes = List.from(state.pinnedNotes);
    List<Note> otherNotes = List.from(state.otherNotes);
    List<Note> selectedNotes = List.from(state.selectedNotes);
    List<Note> archivedNotes = List.from(state.archivedNotes);

    if (event.fromArchiveNotes) {
      for (int i = 0; i < selectedNotes.length; i++) {
        Note note = selectedNotes[i].copyWith(
            selected: false,
            pinned: true,
            trashed: false,
            archived: false,
            dateAdded: DateTime.now().toIso8601String());
        pinnedNotes.add(note);
        int index =
            archivedNotes.indexWhere((element) => element.id == note.id);
        archivedNotes.removeAt(index);
        selectedNotes[i] = note;
      }
      pinnedNotes = sortNotes(pinnedNotes);
      await _apiService.pinUnpinNotes(
        selectedNotes,
        false,
        event.fromArchiveNotes,
      );
    } else {
      if (!event.pinNotes) {
        for (int i = 0; i < selectedNotes.length; i++) {
          Note note = selectedNotes[i];
          if (!note.pinned) {
            int index =
                otherNotes.indexWhere((element) => element.id == note.id);
            otherNotes.removeAt(index);
            Note updatedNote = selectedNotes[i].copyWith(
                pinned: true,
                trashed: false,
                archived: false,
                selected: false,
                dateAdded: DateTime.now().toIso8601String());
            selectedNotes[i] = updatedNote;
            pinnedNotes.add(updatedNote);
          }
        }
        pinnedNotes = sortNotes(pinnedNotes);
      } else {
        for (int i = 0; i < selectedNotes.length; i++) {
          Note note = selectedNotes[i];
          if (note.pinned) {
            int index =
                pinnedNotes.indexWhere((element) => element.id == note.id);
            pinnedNotes.removeAt(index);
            Note updatedNote = selectedNotes[i].copyWith(
                pinned: false,
                trashed: false,
                archived: false,
                selected: false,
                dateAdded: DateTime.now().toIso8601String());
            selectedNotes[i] = updatedNote;
            otherNotes.add(updatedNote);
          }
        }
        otherNotes = sortNotes(otherNotes);
      }
      await _apiService.pinUnpinNotes(
          selectedNotes, event.pinNotes, event.fromArchiveNotes);
    }
    emit(NotesStates(
      pinnedNotes: pinnedNotes,
      otherNotes: otherNotes,
      gridViewMode: state.gridViewMode,
      lightMode: state.lightMode,
      homeNotesSelected: state.homeNotesSelected,
      archiveSelected: state.archiveSelected,
      trashSelected: state.trashSelected,
      trashNotes: state.trashNotes,
      archivedNotes: archivedNotes,
      archiveSearchOn: state.archiveSearchOn,
      homeSearchOn: state.homeSearchOn,
      selectedNotes: const [],
      pinSelectedNotes: false,
      selectedOtherNotes: const [],
      selectedPinnedNotes: const [],
    ));
  }

  Future<void> _bulkUpdateColorNotes(
      BulkUpdateNotes event, Emitter emit) async {
    List<Note> notesList = List.from(event.notesList);
    List<Note> pinnedNotes = List.from(state.pinnedNotes);
    List<Note> otherNotes = List.from(state.otherNotes);
    for (int i = 0; i < notesList.length; i++) {
      if (notesList[i].pinned) {
        int index =
            pinnedNotes.indexWhere((element) => element.id == notesList[i].id);
        pinnedNotes[index] = pinnedNotes[index]
            .copyWith(colorIndex: event.colorIndex, selected: false);
      } else {
        int index =
            otherNotes.indexWhere((element) => element.id == notesList[i].id);
        otherNotes[index] = otherNotes[index]
            .copyWith(colorIndex: event.colorIndex, selected: false);
      }
      notesList[i] = notesList[i].copyWith(
        colorIndex: event.colorIndex,
        selected: false,
      );
    }
    await _apiService.bulkUpdateNotes(notesList);
    emit(NotesStates(
        pinnedNotes: pinnedNotes,
        otherNotes: otherNotes,
        gridViewMode: state.gridViewMode,
        lightMode: state.lightMode,
        homeNotesSelected: state.homeNotesSelected,
        archiveSelected: state.archiveSelected,
        trashSelected: state.trashSelected,
        trashNotes: state.trashNotes,
        archivedNotes: state.archivedNotes,
        archiveSearchOn: state.archiveSearchOn,
        homeSearchOn: state.homeSearchOn,
        selectedNotes: const [],
        pinSelectedNotes: false,
        selectedOtherNotes: const [],
        selectedPinnedNotes: const []));
  }
}
