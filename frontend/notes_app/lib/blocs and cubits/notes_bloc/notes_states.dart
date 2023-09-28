import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class NotesStates extends Equatable {
  final bool gridViewMode;
  final bool lightMode;
  final bool notesSelected;
  final bool archiveSelected;
  final bool trashSelected;
  final List<Note> notes;
  final List<Note> trashNotes;
  final List<Note> archivedNotes;
  final bool archiveSearchOn;

  const NotesStates({
    required this.notes,
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
        notes,
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
    required super.notes,
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
    required super.notes,
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
