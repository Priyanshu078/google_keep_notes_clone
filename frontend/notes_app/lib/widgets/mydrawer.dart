import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/widgets/drawer_listtile.dart';
import 'package:notes_app/widgets/mytext.dart';
import 'package:notes_app/constants/themes.dart' as my_theme;
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.height,
    required this.width,
    required this.scaffoldKey,
  });

  final double height;
  final double width;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(15)),
            color: Theme.of(context).brightness == Brightness.dark
                ? darkModeScaffoldColor
                : Colors.white,
          ),
          width: width * 0.85,
          height: height,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: BlocBuilder<NotesBloc, NotesStates>(
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              style: Theme.of(context).textTheme.headlineLarge,
                              children: [
                                TextSpan(children: [
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "G",
                                      style: GoogleFonts.notoSans(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.blue,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "o",
                                      style: GoogleFonts.notoSans(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.red,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "o",
                                      style: GoogleFonts.notoSans(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.amber,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "g",
                                      style: GoogleFonts.notoSans(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.blue,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "l",
                                      style: GoogleFonts.notoSans(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.green,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "e",
                                      style: GoogleFonts.notoSans(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.red,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                  TextSpan(
                                    text: " Keep",
                                    style: GoogleFonts.notoSans(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.black87,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!state.homeNotesSelected) {
                          context.read<NotesBloc>().add(
                                FetchNotes(
                                  userId: 'priyanshupaliwal',
                                  notes: true,
                                  trashedNotes: false,
                                  archivedNotes: false,
                                ),
                              );
                        }
                        scaffoldKey.currentState!.closeDrawer();
                      },
                      child: DrawerListTile(
                        icon: Icons.lightbulb_outline_rounded,
                        text: "Notes",
                        textColor: state.homeNotesSelected
                            ? selectedTextColor
                            : Colors.black,
                        backgroundColor: state.homeNotesSelected
                            ? Theme.of(context).brightness == Brightness.dark
                                ? darkModeSelectedColor
                                : lightModeSelectedColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? darkModeScaffoldColor
                                : Colors.white,
                        height: height * 0.07,
                        width: width,
                        isTheme: false,
                        themeText: "",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!state.archiveSelected) {
                          context.read<NotesBloc>().add(
                              ArchiveSearchClickedEvent(
                                  archiveSearchOn: false));
                          context.read<NotesBloc>().add(
                                FetchNotes(
                                  userId: 'priyanshupaliwal',
                                  notes: false,
                                  trashedNotes: false,
                                  archivedNotes: true,
                                ),
                              );
                        }
                        scaffoldKey.currentState!.closeDrawer();
                      },
                      child: DrawerListTile(
                        icon: Icons.archive_outlined,
                        text: "Archive",
                        textColor: state.archiveSelected
                            ? selectedTextColor
                            : Colors.black,
                        backgroundColor: state.archiveSelected
                            ? Theme.of(context).brightness == Brightness.dark
                                ? darkModeSelectedColor
                                : lightModeSelectedColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? darkModeScaffoldColor
                                : Colors.white,
                        height: height * 0.07,
                        width: width,
                        isTheme: false,
                        themeText: "",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!state.trashSelected) {
                          context.read<NotesBloc>().add(
                                FetchNotes(
                                  userId: 'priyanshupaliwal',
                                  notes: false,
                                  trashedNotes: true,
                                  archivedNotes: false,
                                ),
                              );
                        }
                        scaffoldKey.currentState!.closeDrawer();
                      },
                      child: DrawerListTile(
                        icon: Icons.delete_outline,
                        text: "Trash",
                        textColor: state.trashSelected
                            ? selectedTextColor
                            : Colors.black,
                        backgroundColor: state.trashSelected
                            ? Theme.of(context).brightness == Brightness.dark
                                ? darkModeSelectedColor
                                : lightModeSelectedColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? darkModeScaffoldColor
                                : Colors.white,
                        height: height * 0.07,
                        width: width,
                        isTheme: false,
                        themeText: "",
                      ),
                    ),
                    BlocBuilder<NotesBloc, NotesStates>(
                        builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: MyText(
                                      text: "Choose Theme",
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RadioListTile(
                                          value: my_theme.Theme.darkMode,
                                          groupValue: state.theme,
                                          onChanged: (val) {
                                            context.read<NotesBloc>().add(
                                                ChangeTheme(
                                                    theme: my_theme
                                                        .Theme.darkMode));
                                            Navigator.of(context).pop();
                                          },
                                          title: MyText(
                                            text: "Dark Mode",
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                        RadioListTile(
                                          value: my_theme.Theme.lightMode,
                                          groupValue: state.theme,
                                          onChanged: (val) {
                                            context.read<NotesBloc>().add(
                                                ChangeTheme(
                                                    theme: my_theme
                                                        .Theme.lightMode));
                                            Navigator.of(context).pop();
                                          },
                                          title: MyText(
                                            text: "Light Mode",
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                        RadioListTile(
                                          value: my_theme.Theme.systemDefault,
                                          groupValue: state.theme,
                                          onChanged: (val) {
                                            context.read<NotesBloc>().add(
                                                ChangeTheme(
                                                    theme: my_theme
                                                        .Theme.systemDefault));
                                            Navigator.of(context).pop();
                                          },
                                          title: MyText(
                                            text: "System default",
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        child: DrawerListTile(
                          icon: Icons.format_paint_outlined,
                          text: "Theme",
                          textColor: Colors.black,
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? darkModeScaffoldColor
                                  : Colors.white,
                          height: height * 0.07,
                          width: width,
                          isTheme: true,
                          themeText: state.theme == my_theme.Theme.lightMode
                              ? "Light"
                              : state.theme == my_theme.Theme.darkMode
                                  ? "Dark"
                                  : "System default",
                        ),
                      );
                    }),
                    DrawerListTile(
                      icon: Icons.help_outline_outlined,
                      text: "Help & feedback",
                      textColor: Colors.black,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? darkModeScaffoldColor
                              : Colors.white,
                      height: height * 0.07,
                      width: width,
                      isTheme: false,
                      themeText: "",
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }
}
