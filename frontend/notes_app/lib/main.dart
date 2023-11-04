import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/authentication/signin_page.dart';
import 'package:notes_app/blocs%20and%20cubits/authentication_cubit/authentication_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_states.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_bloc.dart';
import 'package:notes_app/constants/themes.dart';
import 'package:notes_app/notesbloc_observer.dart';
import 'package:notes_app/pages/homepage.dart';
import 'package:notes_app/constants/themes.dart' as my_theme;
import 'package:notes_app/utils/shared_preferences_utils.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

int appThemeIndex = 3;
bool credentialsAvailable = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesUtils.initialize();
  appThemeIndex = SharedPreferencesUtils.getThemeIndex() ?? 3;
  credentialsAvailable = SharedPreferencesUtils.checkForCredentials();
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
          create: credentialsAvailable
              ? (context) => NotesBloc()
                ..add(
                  FetchNotes(
                    userId: 'priyanshupaliwal',
                    notes: true,
                    trashedNotes: false,
                    archivedNotes: false,
                  ),
                )
              : (context) => NotesBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        )
      ],
      child: BlocBuilder<NotesBloc, NotesStates>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Notes App',
            theme: MyThemes().lightTheme,
            darkTheme: MyThemes().darkTheme,
            themeMode: state.theme == my_theme.Theme.systemDefault
                ? ThemeMode.system
                : state.theme == my_theme.Theme.lightMode
                    ? ThemeMode.light
                    : ThemeMode.dark,
            home: credentialsAvailable
                ? const MyHomePage()
                : BlocProvider(
                    create: (context) => AuthenticationCubit(),
                    child: const SignInPage(),
                  ),
          );
        },
      ),
    );
  }
}
