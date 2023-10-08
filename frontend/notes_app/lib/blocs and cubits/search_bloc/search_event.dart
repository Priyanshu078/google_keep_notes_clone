import 'package:equatable/equatable.dart';

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

  SearchNotesEvent({required this.query});
  @override
  List<Object?> get props => [query];
}
