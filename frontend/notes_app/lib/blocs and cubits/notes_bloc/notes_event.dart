import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddNote extends NotesEvent {
  final Note note;
  AddNote({required this.note});
  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;
  final bool fromTrash;
  final bool fromArchive;
  final bool forArchive;
  final bool forUnArchive;
  final bool pinnedUnarchive;
  final bool homeNotePinned;
  UpdateNote({
    required this.note,
    required this.fromTrash,
    required this.fromArchive,
    required this.forArchive,
    required this.forUnArchive,
    required this.pinnedUnarchive,
    required this.homeNotePinned,
  });
  @override
  List<Object?> get props => [
        note,
        fromTrash,
        fromArchive,
        forArchive,
        forUnArchive,
        pinnedUnarchive,
        homeNotePinned
      ];
}

class TrashNote extends NotesEvent {
  final Note note;
  final bool addNotesPage;
  final bool fromArchive;
  TrashNote(
      {required this.note,
      required this.addNotesPage,
      required this.fromArchive});
  @override
  List<Object?> get props => [note, addNotesPage, fromArchive];
}

class DeleteNote extends NotesEvent {
  final List<Note> noteslist;
  final bool fromSelectedNotes;
  DeleteNote({required this.noteslist, required this.fromSelectedNotes});
  @override
  List<Object?> get props => [noteslist, fromSelectedNotes];
}

class FetchNotes extends NotesEvent {
  final String userId;
  final bool notes;
  final bool trashedNotes;
  final bool archivedNotes;
  FetchNotes({
    required this.userId,
    required this.notes,
    required this.trashedNotes,
    required this.archivedNotes,
  });
  @override
  List<Object?> get props => [userId, notes, trashedNotes, archivedNotes];
}

class ChangeViewEvent extends NotesEvent {}

class ArchiveSearchClickedEvent extends NotesEvent {
  final bool archiveSearchOn;
  ArchiveSearchClickedEvent({required this.archiveSearchOn});
  @override
  List<Object?> get props => [archiveSearchOn];
}

class HomeSearchClickedEvent extends NotesEvent {
  final bool homeSearchOn;
  HomeSearchClickedEvent({required this.homeSearchOn});
  @override
  List<Object?> get props => [homeSearchOn];
}

class EmptyTrashEvent extends NotesEvent {}

class PinNoteEvent extends NotesEvent {
  final Note note;
  PinNoteEvent({required this.note});
  @override
  List<Object?> get props => [note];
}

class SelectNoteEvent extends NotesEvent {
  final Note note;
  final bool homeNotes;
  final bool archivedNotes;
  final bool trashNotes;
  SelectNoteEvent(
      {required this.note,
      required this.homeNotes,
      required this.archivedNotes,
      required this.trashNotes});
  @override
  List<Object?> get props => [note, homeNotes, archivedNotes, trashNotes];
}

class UnselectAllNotesEvent extends NotesEvent {
  final bool homeNotesSelected;
  final bool archivedSelected;
  final bool trashSelected;
  UnselectAllNotesEvent(
      {required this.homeNotesSelected,
      required this.archivedSelected,
      required this.trashSelected});
  @override
  List<Object?> get props =>
      [homeNotesSelected, archivedSelected, trashSelected];
}

class RestoreNotes extends NotesEvent {
  final List<Note> notesList;
  RestoreNotes({required this.notesList});
  @override
  List<Object?> get props => [notesList];
}

class PinUnpinEvent extends NotesEvent {
  final List<Note> notesList;
  final bool pinNotes;
  final bool fromArchiveNotes;
  PinUnpinEvent(
      {required this.notesList,
      required this.pinNotes,
      required this.fromArchiveNotes});
  @override
  List<Object?> get props => [notesList, pinNotes, fromArchiveNotes];
}

class BulkUpdateNotes extends NotesEvent {
  final List<Note> notesList;
  final int colorIndex;
  BulkUpdateNotes({required this.notesList, required this.colorIndex});
  @override
  List<Object?> get props => [notesList, colorIndex];
}

class BulkArchiveUnarchiveEvent extends NotesEvent {
  final List<Note> notesList;
  final bool archive;
  BulkArchiveUnarchiveEvent({required this.notesList, required this.archive});
  @override
  List<Object?> get props => [notesList, archive];
}

class BulkTrashEvent extends NotesEvent {
  final List<Note> notesList;
  BulkTrashEvent({required this.notesList});
  @override
  List<Object?> get props => [notesList];
}
