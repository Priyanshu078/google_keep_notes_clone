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
  UpdateNote({required this.note});
  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NotesEvent {
  final Note note;
  final bool addNotesPage;
  DeleteNote({required this.note, required this.addNotesPage});
  @override
  List<Object?> get props => [note, addNotesPage];
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

class EmptyTrashEvent extends NotesEvent {}
