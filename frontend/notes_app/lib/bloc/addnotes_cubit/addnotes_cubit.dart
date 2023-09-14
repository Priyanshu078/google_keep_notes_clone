import 'package:flutter_bloc/flutter_bloc.dart';

import 'addnotes_states.dart';

class AddNotesCubit extends Cubit<AddNotesState> {
  AddNotesCubit() : super(const AddNotesState(pinned: false));
}
