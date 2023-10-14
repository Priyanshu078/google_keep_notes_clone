import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class NotesStates extends Equatable {
  final bool homeSearchOn;
  final bool gridViewMode;
  final bool lightMode;
  final bool homeNotesSelected;
  final bool archiveSelected;
  final bool trashSelected;
  final List<Note> pinnedNotes;
  final List<Note> otherNotes;
  final List<Note> trashNotes;
  final List<Note> archivedNotes;
  final bool archiveSearchOn;
  final List<Note> selectedNotes;

  const NotesStates({
    required this.pinnedNotes,
    required this.otherNotes,
    required this.gridViewMode,
    required this.lightMode,
    required this.homeNotesSelected,
    required this.archiveSelected,
    required this.trashSelected,
    required this.trashNotes,
    required this.archivedNotes,
    required this.archiveSearchOn,
    required this.homeSearchOn,
    required this.selectedNotes,
  });

  @override
  List<Object?> get props => [
        pinnedNotes,
        otherNotes,
        gridViewMode,
        lightMode,
        homeNotesSelected,
        archiveSelected,
        trashSelected,
        trashNotes,
        archivedNotes,
        archiveSearchOn,
        homeSearchOn,
        selectedNotes,
      ];
}

class NotesSelected extends NotesStates {
  const NotesSelected({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}

class NotesLoading extends NotesStates {
  const NotesLoading({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}

class NotesDeleted extends NotesStates {
  const NotesDeleted({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}

class NotesTrashed extends NotesStates {
  const NotesTrashed({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}

class NotesRestored extends NotesStates {
  const NotesRestored({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}

class NotesArchived extends NotesStates {
  const NotesArchived({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}

class NotesUnarchived extends NotesStates {
  const NotesUnarchived({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}

class NotesPinnedUnarchived extends NotesStates {
  const NotesPinnedUnarchived({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.homeNotesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
    required super.homeSearchOn,
    required super.selectedNotes,
  });
}
