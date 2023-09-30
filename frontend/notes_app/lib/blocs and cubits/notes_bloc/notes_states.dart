import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class NotesStates extends Equatable {
  final bool gridViewMode;
  final bool lightMode;
  final bool notesSelected;
  final bool archiveSelected;
  final bool trashSelected;
  final List<Note> pinnedNotes;
  final List<Note> otherNotes;
  final List<Note> trashNotes;
  final List<Note> archivedNotes;
  final bool archiveSearchOn;

  const NotesStates({
    required this.pinnedNotes,
    required this.otherNotes,
    required this.gridViewMode,
    required this.lightMode,
    required this.notesSelected,
    required this.archiveSelected,
    required this.trashSelected,
    required this.trashNotes,
    required this.archivedNotes,
    required this.archiveSearchOn,
  });

  @override
  List<Object?> get props => [
        pinnedNotes,
        otherNotes,
        gridViewMode,
        lightMode,
        notesSelected,
        archiveSelected,
        trashSelected,
        archiveSearchOn,
        trashNotes,
        archivedNotes,
        archiveSearchOn,
      ];
}

class NotesLoading extends NotesStates {
  const NotesLoading({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.notesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
  });
}

class NotesDeleted extends NotesStates {
  const NotesDeleted({
    required super.pinnedNotes,
    required super.otherNotes,
    required super.gridViewMode,
    required super.lightMode,
    required super.notesSelected,
    required super.archiveSelected,
    required super.trashSelected,
    required super.trashNotes,
    required super.archivedNotes,
    required super.archiveSearchOn,
  });
}
