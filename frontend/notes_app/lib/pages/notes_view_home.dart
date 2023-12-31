import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/widgets/my_note.dart';
import '../blocs and cubits/addnotes_cubit/addnotes_cubit.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../widgets/mytext.dart';

class NotesViewHome extends StatelessWidget {
  const NotesViewHome({
    super.key,
    required this.height,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double height;

  void moveToUpdatePage(BuildContext context, int index, bool pinnedNotes) {
    var state = context.read<NotesBloc>().state;
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => AddNotesCubit()
                    ..setNoteData(
                      note: pinnedNotes
                          ? state.pinnedNotes[index]
                          : state.otherNotes[index],
                      inTrash: false,
                      inArchive: false,
                    ))
            ],
            child: AddNewNotePage(
              isUpdate: true,
              isArchiveUpdate: false,
              note: pinnedNotes
                  ? state.pinnedNotes[index]
                  : state.otherNotes[index],
              pinnedNote: pinnedNotes,
              isSearchUpdate: false,
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesStates>(builder: (context, state) {
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
          : (state.pinnedNotes.isEmpty && state.otherNotes.isEmpty)
              ? SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    SizedBox(
                        height: height * 0.75,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
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
                              text: "Notes you add appear here",
                              textStyle:
                                  Theme.of(context).textTheme.displayMedium,
                            )
                          ],
                        ))
                  ]),
                )
              : state.gridViewMode
                  ? SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          state.pinnedNotes.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: SizedBox(
                                    height: height * 0.06,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: MyText(
                                        text: "Pinned",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.pinnedNotes.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: ((_, index) {
                              return MyNote(
                                  onTap: () {
                                    if (state is NotesSelected) {
                                      context
                                          .read<NotesBloc>()
                                          .add(SelectNoteEvent(
                                            note: state.pinnedNotes[index],
                                            homeNotes: true,
                                            archivedNotes: false,
                                            trashNotes: false,
                                          ));
                                    } else {
                                      moveToUpdatePage(context, index, true);
                                    }
                                  },
                                  onLongPress: () {
                                    context
                                        .read<NotesBloc>()
                                        .add(SelectNoteEvent(
                                          note: state.pinnedNotes[index],
                                          homeNotes: true,
                                          archivedNotes: false,
                                          trashNotes: false,
                                        ));
                                  },
                                  color: getColor(
                                    context,
                                    state,
                                    state.pinnedNotes[index].colorIndex,
                                  ),
                                  border: state.pinnedNotes[index].selected
                                      ? Border.all(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? selectedBorderColorDarkMode
                                              : selectedBorderColorLightMode,
                                          width: 3)
                                      : (state.pinnedNotes[index].colorIndex) ==
                                              0
                                          ? Border.all(color: Colors.grey)
                                          : null,
                                  titleText: state.pinnedNotes[index].title,
                                  contentText: state.pinnedNotes[index].content,
                                  height: height);
                            }),
                          ),
                          (state.pinnedNotes.isNotEmpty &&
                                  state.otherNotes.isNotEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: SizedBox(
                                    height: height * 0.06,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: MyText(
                                        text: "Others",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          state.pinnedNotes.isEmpty
                              ? SizedBox(
                                  height: height * 0.01,
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: height * 0.065,
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.otherNotes.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: ((_, index) {
                                return MyNote(
                                    onTap: () {
                                      if (state is NotesSelected) {
                                        context
                                            .read<NotesBloc>()
                                            .add(SelectNoteEvent(
                                              note: state.otherNotes[index],
                                              homeNotes: true,
                                              archivedNotes: false,
                                              trashNotes: false,
                                            ));
                                      } else {
                                        moveToUpdatePage(context, index, false);
                                      }
                                    },
                                    onLongPress: () {
                                      context
                                          .read<NotesBloc>()
                                          .add(SelectNoteEvent(
                                            note: state.otherNotes[index],
                                            homeNotes: true,
                                            archivedNotes: false,
                                            trashNotes: false,
                                          ));
                                    },
                                    color: getColor(context, state,
                                        state.otherNotes[index].colorIndex),
                                    border: state.otherNotes[index].selected
                                        ? Border.all(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? selectedBorderColorDarkMode
                                                : selectedBorderColorLightMode,
                                            width: 3)
                                        : (state.otherNotes[index]
                                                    .colorIndex) ==
                                                0
                                            ? Border.all(color: Colors.grey)
                                            : null,
                                    titleText: state.otherNotes[index].title,
                                    contentText:
                                        state.otherNotes[index].content,
                                    height: height);
                              }),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate([
                      state.pinnedNotes.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                height: height * 0.06,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: MyText(
                                    text: "Pinned",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.pinnedNotes.length,
                        itemBuilder: ((_, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                            child: MyNote(
                                onTap: () {
                                  if (state is NotesSelected) {
                                    context
                                        .read<NotesBloc>()
                                        .add(SelectNoteEvent(
                                          note: state.pinnedNotes[index],
                                          homeNotes: true,
                                          archivedNotes: false,
                                          trashNotes: false,
                                        ));
                                  } else {
                                    moveToUpdatePage(context, index, true);
                                  }
                                },
                                onLongPress: () {
                                  context.read<NotesBloc>().add(SelectNoteEvent(
                                        note: state.pinnedNotes[index],
                                        homeNotes: true,
                                        archivedNotes: false,
                                        trashNotes: false,
                                      ));
                                },
                                color: getColor(context, state,
                                    state.pinnedNotes[index].colorIndex),
                                border: state.pinnedNotes[index].selected
                                    ? Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? selectedBorderColorDarkMode
                                            : selectedBorderColorLightMode,
                                        width: 3)
                                    : (state.pinnedNotes[index].colorIndex) == 0
                                        ? Border.all(color: Colors.grey)
                                        : null,
                                titleText: state.pinnedNotes[index].title,
                                contentText: state.pinnedNotes[index].content,
                                height: height),
                          );
                        }),
                      ),
                      (state.pinnedNotes.isNotEmpty &&
                              state.otherNotes.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                height: height * 0.06,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: MyText(
                                    text: "Others",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      state.pinnedNotes.isEmpty
                          ? SizedBox(
                              height: height * 0.01,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.065),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.otherNotes.length,
                          itemBuilder: ((_, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                              child: MyNote(
                                  onTap: () {
                                    if (state is NotesSelected) {
                                      context
                                          .read<NotesBloc>()
                                          .add(SelectNoteEvent(
                                            note: state.otherNotes[index],
                                            homeNotes: true,
                                            archivedNotes: false,
                                            trashNotes: false,
                                          ));
                                    } else {
                                      moveToUpdatePage(context, index, false);
                                    }
                                  },
                                  onLongPress: () {
                                    context
                                        .read<NotesBloc>()
                                        .add(SelectNoteEvent(
                                          note: state.otherNotes[index],
                                          homeNotes: true,
                                          archivedNotes: false,
                                          trashNotes: false,
                                        ));
                                  },
                                  color: getColor(context, state,
                                      state.otherNotes[index].colorIndex),
                                  border: state.otherNotes[index].selected
                                      ? Border.all(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? selectedBorderColorDarkMode
                                              : selectedBorderColorLightMode,
                                          width: 3)
                                      : (state.otherNotes[index].colorIndex) ==
                                              0
                                          ? Border.all(color: Colors.grey)
                                          : null,
                                  titleText: state.otherNotes[index].title,
                                  contentText: state.otherNotes[index].content,
                                  height: height),
                            );
                          }),
                        ),
                      ),
                    ]));
    });
  }
}
