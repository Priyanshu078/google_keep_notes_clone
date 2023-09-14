import 'package:equatable/equatable.dart';

class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddNote extends NotesEvent {}

class UpdateNote extends NotesEvent {}

class DeleteNote extends NotesEvent {}

class FetchNotes extends NotesEvent {
  final String userId;
  FetchNotes({required this.userId});
  @override
  List<Object?> get props => [userId];
}
