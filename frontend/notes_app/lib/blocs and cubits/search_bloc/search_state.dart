import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class SearchState extends Equatable {
  final List<Note> searchedNotes;
  final bool homeNotes;

  const SearchState({required this.searchedNotes, required this.homeNotes});
  @override
  List<Object?> get props => [searchedNotes, homeNotes];
}

class SearchInitial extends SearchState {
  const SearchInitial({required super.searchedNotes, required super.homeNotes});
  @override
  List<Object?> get props => [searchedNotes, homeNotes];
}
