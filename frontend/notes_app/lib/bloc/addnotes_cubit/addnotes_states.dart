import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class AddNotesState extends Equatable {
  final Note note;

  const AddNotesState({required this.note});
  @override
  List<Object?> get props => [note];
}
