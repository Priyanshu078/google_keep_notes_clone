import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class NotesStates extends Equatable {
  final List<Note> notes;

  const NotesStates({required this.notes});

  @override
  List<Object?> get props => [notes];
}
