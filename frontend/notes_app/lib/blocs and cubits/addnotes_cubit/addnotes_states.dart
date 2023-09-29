import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class AddNotesState extends Equatable {
  final Note note;
  final int colorIndex;
  final bool inTrash;

  const AddNotesState({
    required this.note,
    required this.colorIndex,
    required this.inTrash,
  });
  @override
  List<Object?> get props => [note, colorIndex, inTrash];
}
