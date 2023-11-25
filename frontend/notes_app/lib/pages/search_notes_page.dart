import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/authentication/signin_page.dart';
import 'package:notes_app/blocs%20and%20cubits/addnotes_cubit/addnotes_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/authentication_cubit/authentication_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_states.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/blocs and cubits/search_bloc/search_state.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/utils/shared_preferences_utils.dart';
import 'package:notes_app/utils/utilities.dart';
import 'package:notes_app/widgets/my_note.dart';
import 'package:notes_app/widgets/mytext.dart';

import '../blocs and cubits/authentication_cubit/authentication_states.dart';

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
              isSearchUpdate: true,
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
            headerHintStyle: Theme.of(context).textTheme.labelMedium,
            searchController: controller,
            dividerColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : darkModeScaffoldColor,
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
                hintText: notesState is NotesSelected
                    ? "${notesState.selectedNotes.length}"
                    : "Search your notes",
                hintStyle: notesState is NotesSelected
                    ? MaterialStatePropertyAll(
                        Theme.of(context).textTheme.labelLarge)
                    : MaterialStatePropertyAll(
                        Theme.of(context).textTheme.labelMedium),
                leading: IconButton(
                  icon: notesState is NotesSelected
                      ? const Icon(Icons.close)
                      : const Icon(Icons.menu),
                  onPressed: () {
                    if (notesState is NotesSelected) {
                      context.read<NotesBloc>().add(UnselectAllNotesEvent(
                            homeNotesSelected: notesState.homeNotesSelected,
                            archivedSelected: notesState.archiveSelected,
                            trashSelected: notesState.trashSelected,
                          ));
                    } else {
                      scaffoldKey.currentState!.openDrawer();
                    }
                  },
                ),
                focusNode: focusNode,
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
                controller: controller,
                onTap: () {
                  if (notesState is! NotesSelected) {
                    if (notesState.homeNotesSelected) {
                      controller.openView();
                      FocusScope.of(context).requestFocus(focusNode);
                    }
                  }
                },
                onChanged: (value) {
                  if (notesState is! NotesSelected) {
                    if (notesState.homeNotesSelected) {
                      controller.openView();
                    }
                  }
                },
                trailing: [
                  notesState is NotesSelected
                      ? IconButton(
                          icon: notesState.pinSelectedNotes
                              ? Icon(
                                  CupertinoIcons.pin_fill,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                )
                              : Icon(
                                  CupertinoIcons.pin,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                          onPressed: () {
                            var state = context.read<NotesBloc>().state;
                            context.read<NotesBloc>().add(
                                  PinUnpinEvent(
                                    notesList: state.selectedNotes,
                                    pinNotes: state.pinSelectedNotes,
                                    fromArchiveNotes: state.archiveSelected,
                                  ),
                                );
                          },
                        )
                      : Container(),
                  notesState is NotesSelected
                      ? IconButton(
                          icon: Icon(
                            Icons.color_lens_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? themeColorDarkMode
                                              : bottomBannerColor,
                                      title: MyText(
                                        text: "Note Color",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      content: SizedBox(
                                        height: height * 0.3,
                                        width: width * 0.9,
                                        child: GridView(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4),
                                          children: List.generate(
                                              // lightMode and darkMode has same number of colors
                                              colorsLightMode.length,
                                              (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<NotesBloc>()
                                                            .add(
                                                              BulkUpdateNotes(
                                                                  notesList:
                                                                      notesState
                                                                          .selectedNotes,
                                                                  colorIndex:
                                                                      index),
                                                            );
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: getColor(
                                                                    context,
                                                                    notesState,
                                                                    index),
                                                                shape: BoxShape
                                                                    .circle),
                                                        height: height * 0.1,
                                                        width: height * 0.1,
                                                      ),
                                                    ),
                                                  )).toList(),
                                        ),
                                      ),
                                    ));
                          },
                        )
                      : Container(),
                  notesState is NotesSelected
                      ? IconButton(
                          icon: Icon(
                            Icons.more_vert_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          onPressed: () {
                            showMenu(
                                context: context,
                                position:
                                    const RelativeRect.fromLTRB(100, 0, 0, 0),
                                items: [
                                  PopupMenuItem(
                                      onTap: () {
                                        context
                                            .read<NotesBloc>()
                                            .add(BulkArchiveUnarchiveEvent(
                                              notesList:
                                                  notesState.selectedNotes,
                                              archive:
                                                  notesState.homeNotesSelected,
                                            ));
                                      },
                                      child: MyText(
                                        text: notesState.homeNotesSelected
                                            ? "Archive"
                                            : "Unrchive",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      )),
                                  PopupMenuItem(
                                      onTap: () {
                                        context
                                            .read<NotesBloc>()
                                            .add(BulkTrashEvent(
                                              notesList:
                                                  notesState.selectedNotes,
                                            ));
                                      },
                                      child: MyText(
                                        text: "Delete",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      )),
                                ]);
                          },
                        )
                      : Container(),
                  notesState.archiveSelected && notesState is! NotesSelected
                      ? IconButton(
                          icon: Icon(
                            Icons.search,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          onPressed: () {
                            controller.openView();
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                        )
                      : Container(),
                  notesState is NotesSelected
                      ? Container()
                      : BlocBuilder<NotesBloc, NotesStates>(
                          builder: (context, state) {
                            return IconButton(
                              onPressed: () {
                                context
                                    .read<NotesBloc>()
                                    .add(ChangeViewEvent());
                              },
                              icon: state.gridViewMode
                                  ? Icon(
                                      Icons.view_agenda_outlined,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    )
                                  : Icon(
                                      Icons.grid_view_outlined,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                            );
                          },
                        ),
                  (notesState.homeNotesSelected && notesState is! NotesSelected)
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? themeColorDarkMode
                                                : bottomBannerColor,
                                        title: ListTile(
                                          minLeadingWidth: 0,
                                          contentPadding: EdgeInsets.zero,
                                          leading: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                SharedPreferencesUtils
                                                    .imageUrl!),
                                          ),
                                          title: MyText(
                                            text: SharedPreferencesUtils.name!,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          subtitle: MyText(
                                            text: SharedPreferencesUtils.email!,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BlocConsumer<AuthenticationCubit,
                                                AuthenticationStates>(
                                              listener: (context, state) {
                                                if (state
                                                    is AuthenticationInitial) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignInPage()));
                                                } else if (state
                                                    is AuthenticationErrorState) {
                                                  Utilities().showSnackBar(
                                                      context,
                                                      "Please try again !!!");
                                                }
                                              },
                                              builder: (context, state) {
                                                return state
                                                        is AuthenticationLoading
                                                    ? CircularProgressIndicator(
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        strokeWidth: 2,
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  AuthenticationCubit>()
                                                              .signOutWithGoogle();
                                                        },
                                                        child: MyText(
                                                          text: "Sign out",
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge,
                                                        ),
                                                      );
                                              },
                                            ),
                                          ],
                                        ),
                                      ));
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                  SharedPreferencesUtils.imageUrl!),
                            ),
                          ),
                        )
                      : Container()
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
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : darkModeScaffoldColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
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
                                  text: "Search your Notes",
                                  textStyle:
                                      Theme.of(context).textTheme.displayMedium,
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
                                            // context.read<NotesBloc>().add(
                                            //     TrashNote(
                                            //         note: state
                                            //             .searchedNotes[index],
                                            //         addNotesPage: false));
                                          },
                                          color: getColor(
                                              context,
                                              notesState,
                                              state.searchedNotes[index]
                                                  .colorIndex),
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
                                              // context.read<NotesBloc>().add(
                                              //     TrashNote(
                                              //         note: state
                                              //             .searchedNotes[index],
                                              //         addNotesPage: false));
                                            },
                                            color: getColor(
                                                context,
                                                notesState,
                                                state.searchedNotes[index]
                                                    .colorIndex),
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
            suggestionsBuilder: (BuildContext suggestionBuilderContext,
                SearchController controller) {
              var state = context.read<NotesBloc>().state;
              if (state.homeNotesSelected) {
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
