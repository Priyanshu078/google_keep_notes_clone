import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/addnotes_cubit/addnotes_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_states.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/blocs and cubits/search_bloc/search_state.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/widgets/my_note.dart';
import 'package:notes_app/widgets/mytext.dart';

class SearchNotesPage extends StatelessWidget {
  const SearchNotesPage({
    super.key,
    required this.height,
    required this.width,
    required this.controller,
    required this.focusNode,
    required this.scaffoldKey,
  });

  final double height;
  final double width;
  final SearchController controller;
  final FocusNode focusNode;
  final GlobalKey<ScaffoldState> scaffoldKey;

  void moveToUpdatePage(BuildContext context, int index) {
    var state = context.read<SearchBloc>().state;
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => AddNotesCubit()
                    ..setNoteData(
                      note: state.searchedNotes[index],
                      inTrash: false,
                      inArchive: !state.homeNotes,
                    ))
            ],
            child: AddNewWidgetPage(
              isUpdate: state.homeNotes,
              isArchiveUpdate: !state.homeNotes,
              note: state.searchedNotes[index],
              pinnedNote: state.searchedNotes[index].pinned,
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    var notesState = context.read<NotesBloc>().state;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (searchBlocContext, searchState) {
        return SearchAnchor(
            viewHintText: "Search your notes",
            searchController: controller,
            dividerColor: Colors.white,
            viewLeading: IconButton(
                onPressed: () {
                  controller.closeView("");
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: const Icon(Icons.arrow_back)),
            isFullScreen: true,
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                ),
                hintText: "Search your notes",
                hintStyle: const MaterialStatePropertyAll(TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54)),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
                focusNode: focusNode,
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
                controller: controller,
                onTap: () {
                  if (notesState.notesSelected) {
                    controller.openView();
                    FocusScope.of(context).requestFocus(focusNode);
                  }
                },
                onChanged: (value) {
                  if (notesState.notesSelected) {
                    controller.openView();
                  }
                },
                trailing: [
                  notesState.archiveSelected
                      ? IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            controller.openView();
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                        )
                      : Container(),
                  BlocBuilder<NotesBloc, NotesStates>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          context.read<NotesBloc>().add(ChangeViewEvent());
                        },
                        icon: state.gridViewMode
                            ? const Icon(Icons.view_agenda_outlined)
                            : const Icon(
                                Icons.grid_view_outlined,
                              ),
                      );
                    },
                  ),
                  // notesState.archiveSelected
                  //     ? BlocBuilder<NotesBloc, NotesStates>(
                  //         builder: (context, state) {
                  //           return IconButton(
                  //             onPressed: () {
                  //               context
                  //                   .read<NotesBloc>()
                  //                   .add(ChangeViewEvent());
                  //             },
                  //             icon: state.gridViewMode
                  //                 ? const Icon(Icons.view_agenda_outlined)
                  //                 : const Icon(
                  //                     Icons.grid_view_outlined,
                  //                   ),
                  //           );
                  //         },
                  //       )
                  //     : Container(),
                ],
              );
            },
            viewBuilder: (suggestions) {
              return BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return state is SearchInitial
                      ? Container(
                          height: height,
                          width: width,
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: Colors.amber,
                                  size: 130,
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                const MyText(
                                  text: "Search your Notes",
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: height,
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: notesState.gridViewMode
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.searchedNotes.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                    itemBuilder: ((_, index) {
                                      return MyNote(
                                          onTap: () {
                                            moveToUpdatePage(context, index);
                                          },
                                          onLongPress: () {
                                            context.read<NotesBloc>().add(
                                                TrashNote(
                                                    note: state
                                                        .searchedNotes[index],
                                                    addNotesPage: false));
                                          },
                                          color: colors[state
                                              .searchedNotes[index].colorIndex],
                                          border: (state.searchedNotes[index]
                                                      .colorIndex) ==
                                                  0
                                              ? Border.all(color: Colors.grey)
                                              : null,
                                          titleText:
                                              state.searchedNotes[index].title,
                                          contentText: state
                                              .searchedNotes[index].content,
                                          height: height);
                                    }),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.searchedNotes.length,
                                    itemBuilder: ((_, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: index == 0 ? 0 : 8.0),
                                        child: MyNote(
                                            onTap: () {
                                              moveToUpdatePage(context, index);
                                            },
                                            onLongPress: () {
                                              context.read<NotesBloc>().add(
                                                  TrashNote(
                                                      note: state
                                                          .searchedNotes[index],
                                                      addNotesPage: false));
                                            },
                                            color: colors[state
                                                .searchedNotes[index]
                                                .colorIndex],
                                            border: (state.searchedNotes[index]
                                                        .colorIndex) ==
                                                    0
                                                ? Border.all(color: Colors.grey)
                                                : null,
                                            titleText: state
                                                .searchedNotes[index].title,
                                            contentText: state
                                                .searchedNotes[index].content,
                                            height: height),
                                      );
                                    }),
                                  ),
                          ));
                },
              );
            },
            suggestionsBuilder: (BuildContext suggestionBuildercontext,
                SearchController controller) {
              var state = context.read<NotesBloc>().state;
              if (state.notesSelected) {
                if (controller.text == "" || controller.text.isEmpty) {
                  searchBlocContext
                      .read<SearchBloc>()
                      .add(SearchInitialEvent(homeSearch: true));
                } else {
                  searchBlocContext.read<SearchBloc>().add(SearchNotesEvent(
                        query: controller.text,
                        pinnedNotes: state.pinnedNotes,
                        otherNotes: state.otherNotes,
                        archiveNotes: const [],
                        homeSearch: true,
                      ));
                }
              } else if (state.archiveSelected) {
                if (controller.text == "" || controller.text.isEmpty) {
                  searchBlocContext
                      .read<SearchBloc>()
                      .add(SearchInitialEvent(homeSearch: false));
                } else {
                  searchBlocContext.read<SearchBloc>().add(SearchNotesEvent(
                        query: controller.text,
                        pinnedNotes: const [],
                        otherNotes: const [],
                        archiveNotes: state.archivedNotes,
                        homeSearch: false,
                      ));
                }
              }
              return <Widget>[Text(controller.text)];
            });
      },
    );
  }
}
