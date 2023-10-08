import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class SearchState extends Equatable {
  final List<Note> searchedNotes;

  const SearchState({required this.searchedNotes});
  @override
  List<Object?> get props => [searchedNotes];
}

class SearchInitial extends SearchState {
  const SearchInitial({required super.searchedNotes});
  @override
  List<Object?> get props => [searchedNotes];
}
