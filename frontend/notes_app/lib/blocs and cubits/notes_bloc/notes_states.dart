import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class NotesStates extends Equatable {
  final bool gridViewMode;
  final bool lightMode;
  final List<Note> notes;

  const NotesStates(
      {required this.notes,
      required this.gridViewMode,
      required this.lightMode});

  @override
  List<Object?> get props => [notes, gridViewMode, lightMode];
}

class NotesLoading extends NotesStates {
  const NotesLoading(
      {required super.notes,
      required super.gridViewMode,
      required super.lightMode});
}

class NotesDeleted extends NotesStates {
  const NotesDeleted(
      {required super.notes,
      required super.gridViewMode,
      required super.lightMode});
}
