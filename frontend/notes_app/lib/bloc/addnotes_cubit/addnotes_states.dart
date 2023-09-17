import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class AddNotesState extends Equatable {
  final Note note;
  final Color color;

  const AddNotesState({required this.note, required this.color});
  @override
  List<Object?> get props => [note, color];
}
