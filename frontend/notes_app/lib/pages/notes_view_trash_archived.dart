import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/pages/add_new_note.dart';

import '../blocs and cubits/addnotes_cubit/addnotes_cubit.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_event.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../constants/colors.dart';
import '../widgets/mytext.dart';

class NotesViewTrashArchived extends StatelessWidget {
  const NotesViewTrashArchived({
    super.key,
    required this.height,
    required this.inArchivedNotes,
    required this.inTrashedNotes,
    required this.pinnedNotes,
  });

  final double height;
  final bool inArchivedNotes;
  final bool inTrashedNotes;
  final bool pinnedNotes;

  void moveToUpdatePage(BuildContext context, int index) {
    var state = context.read<NotesBloc>().state;
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => AddNotesCubit()
                    ..setNoteData(
                        note: inArchivedNotes
                            ? state.archivedNotes[index]
                            : inTrashedNotes
                                ? state.trashNotes[index]
                                : pinnedNotes
                                    ? state.pinnedNotes[index]
                                    : state.otherNotes[index],
                        inTrash: inTrashedNotes))
            ],
            child: AddNewWidgetPage(
              isUpdate: true,
              note: inArchivedNotes
                  ? state.archivedNotes[index]
                  : inTrashedNotes
                      ? state.trashNotes[index]
                      : pinnedNotes
                          ? state.pinnedNotes[index]
                          : state.otherNotes[index],
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    var state = context.read<NotesBloc>().state;
    return state is NotesLoading
        ? SliverList(
            delegate: SliverChildListDelegate.fixed([
              SizedBox(
                height: height * 0.75,
                width: double.infinity,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ]),
          )
        : (inArchivedNotes
                ? state.archivedNotes.isEmpty
                : inTrashedNotes
                    ? state.trashNotes.isEmpty
                    : pinnedNotes
                        ? state.pinnedNotes.isEmpty
                        : state.otherNotes.isEmpty)
            ? SliverList(
                delegate: SliverChildListDelegate.fixed([
                  SizedBox(
                      height: height * 0.75,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            inArchivedNotes
                                ? Icons.archive_outlined
                                : inTrashedNotes
                                    ? Icons.delete_outline
                                    : Icons.lightbulb_outline_rounded,
                            color: Colors.amber,
                            size: 130,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          MyText(
                            text: inArchivedNotes
                                ? "Your archived notes appear here"
                                : inTrashedNotes
                                    ? "No notes in Trash"
                                    : "Notes you add appear here",
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          )
                        ],
                      ))
                ]),
              )
            : state.gridViewMode
                ? SliverGrid.builder(
                    itemCount: inArchivedNotes
                        ? state.archivedNotes.length
                        : inTrashedNotes
                            ? state.trashNotes.length
                            : pinnedNotes
                                ? state.pinnedNotes.length
                                : state.otherNotes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: ((_, index) {
                      return GestureDetector(
                        onTap: () {
                          moveToUpdatePage(context, index);
                        },
                        onLongPress: () {
                          context.read<NotesBloc>().add(DeleteNote(
                              note: inArchivedNotes
                                  ? state.archivedNotes[index]
                                  : inTrashedNotes
                                      ? state.trashNotes[index]
                                      : pinnedNotes
                                          ? state.pinnedNotes[index]
                                          : state.otherNotes[index],
                              addNotesPage: false));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: colors[inArchivedNotes
                                  ? state.archivedNotes[index].colorIndex
                                  : inTrashedNotes
                                      ? state.trashNotes[index].colorIndex
                                      : pinnedNotes
                                          ? state.pinnedNotes[index].colorIndex
                                          : state.otherNotes[index].colorIndex],
                              border: (inArchivedNotes
                                          ? state
                                              .archivedNotes[index].colorIndex
                                          : inTrashedNotes
                                              ? state
                                                  .trashNotes[index].colorIndex
                                              : pinnedNotes
                                                  ? state.pinnedNotes[index]
                                                      .colorIndex
                                                  : state.otherNotes[index]
                                                      .colorIndex) ==
                                      0
                                  ? Border.all(color: Colors.grey)
                                  : null,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: inArchivedNotes
                                        ? state.archivedNotes[index].title
                                        : inTrashedNotes
                                            ? state.trashNotes[index].title
                                            : pinnedNotes
                                                ? state.pinnedNotes[index].title
                                                : state.otherNotes[index].title,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                MyText(
                                  text: inArchivedNotes
                                      ? state.archivedNotes[index].content
                                      : inTrashedNotes
                                          ? state.trashNotes[index].content
                                          : pinnedNotes
                                              ? state.pinnedNotes[index].content
                                              : state.otherNotes[index].content,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                : SliverList.builder(
                    itemCount: inArchivedNotes
                        ? state.archivedNotes.length
                        : inTrashedNotes
                            ? state.trashNotes.length
                            : pinnedNotes
                                ? state.pinnedNotes.length
                                : state.otherNotes.length,
                    itemBuilder: ((_, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                        child: GestureDetector(
                          onTap: () {
                            moveToUpdatePage(context, index);
                          },
                          onLongPress: () {
                            context.read<NotesBloc>().add(DeleteNote(
                                note: inArchivedNotes
                                    ? state.archivedNotes[index]
                                    : inTrashedNotes
                                        ? state.trashNotes[index]
                                        : pinnedNotes
                                            ? state.pinnedNotes[index]
                                            : state.otherNotes[index],
                                addNotesPage: false));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: colors[inArchivedNotes
                                    ? state.archivedNotes[index].colorIndex
                                    : inTrashedNotes
                                        ? state.trashNotes[index].colorIndex
                                        : pinnedNotes
                                            ? state
                                                .pinnedNotes[index].colorIndex
                                            : state
                                                .otherNotes[index].colorIndex],
                                border: (inArchivedNotes
                                            ? state
                                                .archivedNotes[index].colorIndex
                                            : inTrashedNotes
                                                ? state.trashNotes[index]
                                                    .colorIndex
                                                : pinnedNotes
                                                    ? state.pinnedNotes[index]
                                                        .colorIndex
                                                    : state.otherNotes[index]
                                                        .colorIndex) ==
                                        0
                                    ? Border.all(color: Colors.grey)
                                    : null,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: inArchivedNotes
                                          ? state.archivedNotes[index].title
                                          : inTrashedNotes
                                              ? state.trashNotes[index].title
                                              : pinnedNotes
                                                  ? state
                                                      .pinnedNotes[index].title
                                                  : state
                                                      .otherNotes[index].title,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                  MyText(
                                    text: inArchivedNotes
                                        ? state.archivedNotes[index].content
                                        : inTrashedNotes
                                            ? state.trashNotes[index].content
                                            : pinnedNotes
                                                ? state
                                                    .pinnedNotes[index].content
                                                : state
                                                    .otherNotes[index].content,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
  }
}
