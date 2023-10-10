import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitialEvent extends SearchEvent {
  final bool homeSearch;
  SearchInitialEvent({required this.homeSearch});
  @override
  List<Object?> get props => [homeSearch];
}

class SearchNotesEvent extends SearchEvent {
  final String query;
  final bool homeSearch;
  final List<Note> pinnedNotes;
  final List<Note> otherNotes;
  final List<Note> archiveNotes;

  SearchNotesEvent({
    required this.query,
    required this.pinnedNotes,
    required this.otherNotes,
    required this.archiveNotes,
    required this.homeSearch,
  });
  @override
  List<Object?> get props =>
      [query, pinnedNotes, otherNotes, archiveNotes, homeSearch];
}

class RemoveNoteFromSearchEvent extends SearchEvent {
  final Note note;
  final bool homeSearch;
  RemoveNoteFromSearchEvent({required this.note, required this.homeSearch});
  @override
  List<Object?> get props => [note, homeSearch];
}

class UpdateNoteInSearchEvent extends SearchEvent {
  final Note note;
  final bool homeSearch;
  UpdateNoteInSearchEvent({required this.note, required this.homeSearch});
  @override
  List<Object?> get props => [note, homeSearch];
}
