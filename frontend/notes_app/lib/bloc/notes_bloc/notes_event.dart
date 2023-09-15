import 'package:equatable/equatable.dart';
import 'package:notes_app/data/note.dart';

class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddNote extends NotesEvent {
  final Note note;
  AddNote({required this.note});
  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NotesEvent {}

class DeleteNote extends NotesEvent {}

class FetchNotes extends NotesEvent {
  final String userId;
  FetchNotes({required this.userId});
  @override
  List<Object?> get props => [userId];
}
