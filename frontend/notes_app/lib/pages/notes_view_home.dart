import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/pages/add_new_note.dart';

import '../blocs and cubits/addnotes_cubit/addnotes_cubit.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_event.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../constants/colors.dart';
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
            child: AddNewWidgetPage(
              isUpdate: true,
              isArchiveUpdate: false,
              note: pinnedNotes
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
        : (state.pinnedNotes.isEmpty && state.otherNotes.isEmpty)
            ? SliverList(
                delegate: SliverChildListDelegate.fixed([
                  SizedBox(
                      height: height * 0.75,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.amber,
                            size: 130,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          const MyText(
                            text: "Notes you add appear here",
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
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
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: MyText(
                                        text: "Pinned",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
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
                            return GestureDetector(
                              onTap: () {
                                moveToUpdatePage(context, index, true);
                              },
                              onLongPress: () {
                                context.read<NotesBloc>().add(TrashNote(
                                    note: state.pinnedNotes[index],
                                    addNotesPage: false));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: colors[
                                        state.pinnedNotes[index].colorIndex],
                                    border:
                                        (state.pinnedNotes[index].colorIndex) ==
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
                                          text: state.pinnedNotes[index].title,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      MyText(
                                        text: state.pinnedNotes[index].content,
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
                        ),
                        (state.pinnedNotes.isNotEmpty &&
                                state.otherNotes.isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: SizedBox(
                                  height: height * 0.06,
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: MyText(
                                        text: "Others",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              )
                            : Container(),
                        GridView.builder(
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
                            return GestureDetector(
                              onTap: () {
                                moveToUpdatePage(context, index, false);
                              },
                              onLongPress: () {
                                context.read<NotesBloc>().add(TrashNote(
                                    note: state.otherNotes[index],
                                    addNotesPage: false));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: colors[
                                        state.otherNotes[index].colorIndex],
                                    border:
                                        (state.otherNotes[index].colorIndex) ==
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
                                          text: state.otherNotes[index].title,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      MyText(
                                        text: state.otherNotes[index].content,
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
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                    text: "Pinned",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
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
                          child: GestureDetector(
                            onTap: () {
                              moveToUpdatePage(context, index, true);
                            },
                            onLongPress: () {
                              context.read<NotesBloc>().add(TrashNote(
                                  note: state.pinnedNotes[index],
                                  addNotesPage: false));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colors[
                                      state.pinnedNotes[index].colorIndex],
                                  border:
                                      (state.pinnedNotes[index].colorIndex) == 0
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
                                        text: state.pinnedNotes[index].title,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    MyText(
                                      text: state.pinnedNotes[index].content,
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
                    ),
                    (state.pinnedNotes.isNotEmpty &&
                            state.otherNotes.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              height: height * 0.06,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                    text: "Others",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          )
                        : Container(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.otherNotes.length,
                      itemBuilder: ((_, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                          child: GestureDetector(
                            onTap: () {
                              moveToUpdatePage(context, index, false);
                            },
                            onLongPress: () {
                              context.read<NotesBloc>().add(TrashNote(
                                  note: state.otherNotes[index],
                                  addNotesPage: false));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colors[
                                      state.otherNotes[index].colorIndex],
                                  border:
                                      (state.otherNotes[index].colorIndex) == 0
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
                                        text: state.otherNotes[index].title,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    MyText(
                                      text: state.otherNotes[index].content,
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
                    ),
                  ]));
  }
}
