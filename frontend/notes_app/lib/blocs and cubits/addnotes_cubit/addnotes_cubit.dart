import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/note.dart';
import 'addnotes_states.dart';

class AddNotesCubit extends Cubit<AddNotesState> {
  AddNotesCubit() : super(AddNotesState(note: Note.temp(), colorIndex: 0));

  void pinUnpinNote() {
    Note note = state.note.copyWith(pinned: !state.note.pinned);
    emit(AddNotesState(note: note, colorIndex: state.colorIndex));
  }

  void setNoteData(Note note) {
    emit(AddNotesState(note: note, colorIndex: note.colorIndex));
  }

  void setBackgroundColor(int colorIndex) {
    Note note = state.note.copyWith(colorIndex: colorIndex);
    emit(AddNotesState(note: note, colorIndex: colorIndex));
  }
}
