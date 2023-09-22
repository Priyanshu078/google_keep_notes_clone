import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/widgets/drawer_listtile.dart';

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
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
          color: Colors.white,
        ),
        width: width * 0.85,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: BlocBuilder<NotesBloc, NotesStates>(
            builder: (context, state) {
              return Column(
                children: [
                  Image.asset("assets/google-keep-logo.png"),
                  GestureDetector(
                    onTap: () {
                      context.read<NotesBloc>().add(NotesSelectEvent());
                      scaffoldKey.currentState!.closeDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: DrawerListTile(
                        icon: Icons.lightbulb_outline_rounded,
                        text: "Notes",
                        textColor: state.notesSelected
                            ? selectedTextColor
                            : Colors.black,
                        backgroundColor:
                            state.notesSelected ? selectedColor : Colors.white,
                        iconColor: state.notesSelected
                            ? selectedTextColor
                            : Colors.black,
                        height: height * 0.07,
                        width: width,
                        isTheme: false,
                        themeText: "",
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: dividerColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<NotesBloc>().add(ArchiveSelectEvent());
                      scaffoldKey.currentState!.closeDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: DrawerListTile(
                        icon: Icons.archive_outlined,
                        text: "Archive",
                        textColor: state.archiveSelected
                            ? selectedTextColor
                            : Colors.black,
                        backgroundColor: state.archiveSelected
                            ? selectedColor
                            : Colors.white,
                        iconColor: state.archiveSelected
                            ? selectedTextColor
                            : Colors.black,
                        height: height * 0.07,
                        width: width,
                        isTheme: false,
                        themeText: "",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<NotesBloc>().add(TrashSelectEvent());
                      scaffoldKey.currentState!.closeDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: DrawerListTile(
                        icon: Icons.delete_outline,
                        text: "Trash",
                        textColor: state.trashSelected
                            ? selectedTextColor
                            : Colors.black,
                        backgroundColor:
                            state.trashSelected ? selectedColor : Colors.white,
                        iconColor: state.trashSelected
                            ? selectedTextColor
                            : Colors.black,
                        height: height * 0.07,
                        width: width,
                        isTheme: false,
                        themeText: "",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: DrawerListTile(
                      icon: Icons.format_paint_outlined,
                      text: "Theme",
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      iconColor: Colors.black,
                      height: height * 0.07,
                      width: width,
                      isTheme: true,
                      themeText: "Light",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: DrawerListTile(
                      icon: Icons.help_outline_outlined,
                      text: "Help & feedback",
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      iconColor: Colors.black,
                      height: height * 0.07,
                      width: width,
                      isTheme: false,
                      themeText: "",
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
