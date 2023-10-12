import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/pages/add_new_note.dart';

import '../blocs and cubits/addnotes_cubit/addnotes_cubit.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../constants/colors.dart';
import '../widgets/mytext.dart';

class NotesViewTrashArchived extends StatelessWidget {
  const NotesViewTrashArchived({
    super.key,
    required this.height,
    required this.inArchivedNotes,
    required this.inTrashedNotes,
  });

  final double height;
  final bool inArchivedNotes;
  final bool inTrashedNotes;

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
                          : state.trashNotes[index],
                      inTrash: inTrashedNotes,
                      inArchive: inArchivedNotes,
                    ))
            ],
            child: AddNewWidgetPage(
              isUpdate: false,
              isArchiveUpdate: true,
              note: inArchivedNotes
                  ? state.archivedNotes[index]
                  : state.trashNotes[index],
              pinnedNote: false,
              isSearchUpdate: false,
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
                : state.trashNotes.isEmpty)
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
                                : "No notes in Trash",
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
                        : state.trashNotes.length,
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
                          // context.read<NotesBloc>().add(TrashNote(
                          //     note: inArchivedNotes
                          //         ? state.archivedNotes[index]
                          //         : state.trashNotes[index],
                          //     addNotesPage: false));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: colors[inArchivedNotes
                                  ? state.archivedNotes[index].colorIndex
                                  : state.trashNotes[index].colorIndex],
                              border: (inArchivedNotes
                                          ? state
                                              .archivedNotes[index].colorIndex
                                          : state
                                              .trashNotes[index].colorIndex) ==
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
                                        : state.trashNotes[index].title,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                MyText(
                                  text: inArchivedNotes
                                      ? state.archivedNotes[index].content
                                      : state.trashNotes[index].content,
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
                        : state.trashNotes.length,
                    itemBuilder: ((_, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                        child: GestureDetector(
                          onTap: () {
                            moveToUpdatePage(context, index);
                          },
                          onLongPress: () {
                            // context.read<NotesBloc>().add(TrashNote(
                            //     note: inArchivedNotes
                            //         ? state.archivedNotes[index]
                            //         : state.trashNotes[index],
                            //     addNotesPage: false,
                            //     ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: colors[inArchivedNotes
                                    ? state.archivedNotes[index].colorIndex
                                    : state.trashNotes[index].colorIndex],
                                border: (inArchivedNotes
                                            ? state
                                                .archivedNotes[index].colorIndex
                                            : state.trashNotes[index]
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
                                          : state.trashNotes[index].title,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                  MyText(
                                    text: inArchivedNotes
                                        ? state.archivedNotes[index].content
                                        : state.trashNotes[index].content,
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
