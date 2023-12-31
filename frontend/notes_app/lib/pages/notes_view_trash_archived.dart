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
            child: AddNewNotePage(
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
    return BlocBuilder<NotesBloc, NotesStates>(
      builder: (context, state) {
        return state is NotesLoading
            ? SliverList(
                delegate: SliverChildListDelegate.fixed([
                  SizedBox(
                    height: height * 0.75,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeAlign: 2,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
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
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.amber
                                    : Colors.white,
                                size: 130,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              MyText(
                                text: inArchivedNotes
                                    ? "Your archived notes appear here"
                                    : "No notes in Trash",
                                textStyle:
                                    Theme.of(context).textTheme.displayMedium,
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
                              var state = context.read<NotesBloc>().state;
                              if (state is NotesSelected) {
                                context.read<NotesBloc>().add(SelectNoteEvent(
                                      note: state.archiveSelected
                                          ? state.archivedNotes[index]
                                          : state.trashNotes[index],
                                      homeNotes: false,
                                      archivedNotes: state.archiveSelected,
                                      trashNotes: !state.archiveSelected,
                                    ));
                              } else {
                                moveToUpdatePage(context, index);
                              }
                            },
                            onLongPress: () {
                              context.read<NotesBloc>().add(SelectNoteEvent(
                                    note: state.archiveSelected
                                        ? state.archivedNotes[index]
                                        : state.trashNotes[index],
                                    homeNotes: false,
                                    archivedNotes: state.archiveSelected,
                                    trashNotes: !state.archiveSelected,
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: getColor(
                                      context,
                                      state,
                                      inArchivedNotes
                                          ? state
                                              .archivedNotes[index].colorIndex
                                          : state.trashNotes[index].colorIndex),
                                  border: (state.archiveSelected
                                          ? state.archivedNotes[index].selected
                                          : state.trashNotes[index].selected)
                                      ? Border.all(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? selectedBorderColorDarkMode
                                              : selectedBorderColorLightMode,
                                          width: 3)
                                      : (inArchivedNotes
                                                  ? state.archivedNotes[index]
                                                      .colorIndex
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
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    MyText(
                                      text: inArchivedNotes
                                          ? state.archivedNotes[index].content
                                          : state.trashNotes[index].content,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
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
                                if (state is NotesSelected) {
                                  context.read<NotesBloc>().add(SelectNoteEvent(
                                        note: state.archiveSelected
                                            ? state.archivedNotes[index]
                                            : state.trashNotes[index],
                                        homeNotes: false,
                                        archivedNotes: state.archiveSelected,
                                        trashNotes: !state.archiveSelected,
                                      ));
                                } else {
                                  moveToUpdatePage(context, index);
                                }
                              },
                              onLongPress: () {
                                context.read<NotesBloc>().add(SelectNoteEvent(
                                      note: state.archiveSelected
                                          ? state.archivedNotes[index]
                                          : state.trashNotes[index],
                                      homeNotes: false,
                                      archivedNotes: state.archiveSelected,
                                      trashNotes: !state.archiveSelected,
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: getColor(
                                        context,
                                        state,
                                        inArchivedNotes
                                            ? state
                                                .archivedNotes[index].colorIndex
                                            : state
                                                .trashNotes[index].colorIndex),
                                    border: (state.archiveSelected
                                            ? state
                                                .archivedNotes[index].selected
                                            : state.trashNotes[index].selected)
                                        ? Border.all(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? selectedBorderColorDarkMode
                                                : selectedBorderColorLightMode,
                                            width: 3)
                                        : (inArchivedNotes
                                                    ? state.archivedNotes[index]
                                                        .colorIndex
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: inArchivedNotes
                                            ? state.archivedNotes[index].title
                                            : state.trashNotes[index].title,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      MyText(
                                        text: inArchivedNotes
                                            ? state.archivedNotes[index].content
                                            : state.trashNotes[index].content,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
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
      },
    );
  }
}
