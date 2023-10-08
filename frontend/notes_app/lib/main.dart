import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_bloc.dart';
import 'package:notes_app/notesbloc_observer.dart';
import 'package:notes_app/pages/homepage.dart';

void main() {
  Bloc.observer = NotesBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesBloc()
            ..add(
              FetchNotes(
                userId: 'priyanshupaliwal',
                notes: true,
                trashedNotes: false,
                archivedNotes: false,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
