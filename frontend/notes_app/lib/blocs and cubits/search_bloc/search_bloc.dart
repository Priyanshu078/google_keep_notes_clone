import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_event.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchInitial(searchedNotes: [])) {
    on<SearchNotesEvent>((event, emit) => searchNotes(event, emit));
    on<SearchInitialEvent>(
        (event, emit) => const SearchInitial(searchedNotes: []));
  }

  void searchNotes(SearchNotesEvent event, Emitter emit) {
    emit(const SearchState(searchedNotes: []));
  }
}
