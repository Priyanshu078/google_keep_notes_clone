import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_event.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/note.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchInitial(searchedNotes: [])) {
    on<SearchNotesEvent>((event, emit) => searchNotes(event, emit));
    on<SearchInitialEvent>(
        (event, emit) => emit(const SearchInitial(searchedNotes: [])));
    on<RemoveNoteFromSearchEvent>(
        (event, emit) => removeNotesFromSearch(event, emit));
    on<UpdateNoteInSearchEvent>(
        (event, emit) => updateNotesFromSearch(event, emit));
  }

  void updateNotesFromSearch(UpdateNoteInSearchEvent event, Emitter emit) {
    List<Note> searchedNotes = List.from(state.searchedNotes);
    int index =
        searchedNotes.indexWhere((element) => element.id == event.note.id);
    searchedNotes[index] = event.note;
    emit(SearchState(searchedNotes: searchedNotes));
  }

  void removeNotesFromSearch(RemoveNoteFromSearchEvent event, Emitter emit) {
    List<Note> searchedNotes = List.from(state.searchedNotes);
    int index =
        searchedNotes.indexWhere((element) => element.id == event.note.id);
    searchedNotes.removeAt(index);
    emit(SearchState(searchedNotes: searchedNotes));
  }

  void searchNotes(SearchNotesEvent event, Emitter emit) {
    List<Note> allNotes = [];
    allNotes.addAll(event.pinnedNotes);
    allNotes.addAll(event.otherNotes);
    allNotes.retainWhere((element) {
      return element.title.contains(event.query);
    });
    emit(SearchState(searchedNotes: allNotes));
  }
}
