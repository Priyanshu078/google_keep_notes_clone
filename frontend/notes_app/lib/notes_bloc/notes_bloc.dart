import 'package:flutter_bloc/flutter_bloc.dart';

import 'notes_event.dart';
import 'notes_states.dart';

class NotesBloc extends Bloc<NotesEvent, NotesStates> {
  NotesBloc() : super(const NotesStates(notes: []));
}
