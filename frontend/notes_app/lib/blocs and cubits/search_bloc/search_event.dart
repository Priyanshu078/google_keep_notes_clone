import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitialEvent extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class SearchNotesEvent extends SearchEvent {
  final String query;
  final List<Note> pinnedNotes;
  final List<Note> otherNotes;

  SearchNotesEvent(
      {required this.query,
      required this.pinnedNotes,
      required this.otherNotes});
  @override
  List<Object?> get props => [query, pinnedNotes, otherNotes];
}

class RemoveNoteFromSearchEvent extends SearchEvent {
  final Note note;
  RemoveNoteFromSearchEvent({required this.note});
  @override
  List<Object?> get props => [note];
}

class UpdateNoteInSearchEvent extends SearchEvent {
  final Note note;
  UpdateNoteInSearchEvent({required this.note});
  @override
  List<Object?> get props => [note];
}
