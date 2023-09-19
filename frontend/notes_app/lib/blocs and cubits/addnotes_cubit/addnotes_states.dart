import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class AddNotesState extends Equatable {
  final Note note;
  final int colorIndex;

  const AddNotesState({required this.note, required this.colorIndex});
  @override
  List<Object?> get props => [note, colorIndex];
}
