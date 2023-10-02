import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/note.dart';
import 'addnotes_states.dart';

class AddNotesCubit extends Cubit<AddNotesState> {
  AddNotesCubit()
      : super(AddNotesState(
            note: Note.temp(),
            colorIndex: 0,
            inTrash: false,
            inArchive: false));

  void pinUnpinNote() {
    Note note = state.note.copyWith(pinned: !state.note.pinned);
    emit(AddNotesState(
        note: note,
        colorIndex: state.colorIndex,
        inTrash: state.inTrash,
        inArchive: state.inArchive));
  }

  void setNoteData(
      {required Note note, required bool inTrash, required bool inArchive}) {
    emit(AddNotesState(
        note: note,
        colorIndex: note.colorIndex,
        inTrash: inTrash,
        inArchive: inArchive));
  }

  void setBackgroundColor(int colorIndex) {
    Note note = state.note.copyWith(colorIndex: colorIndex);
    emit(AddNotesState(
        note: note,
        colorIndex: colorIndex,
        inTrash: state.inTrash,
        inArchive: state.inArchive));
  }
}
