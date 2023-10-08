import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_states.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_bloc.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/blocs and cubits/search_bloc/search_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesStates>(
      builder: (context, notesState) {
        return BlocBuilder<SearchBloc, SearchState>(
          builder: (context, searchState) {
            return SearchAnchor(
                viewHintText: "Search your notes",
                searchController: controller,
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
                      controller.openView();
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                    onChanged: (value) {
                      controller.openView();
                    },
                    trailing: [
                      notesState.notesSelected
                          ? BlocBuilder<NotesBloc, NotesStates>(
                              builder: (context, state) {
                                return IconButton(
                                  onPressed: () {
                                    context
                                        .read<NotesBloc>()
                                        .add(ChangeViewEvent());
                                  },
                                  icon: state.gridViewMode
                                      ? const Icon(Icons.view_agenda_outlined)
                                      : const Icon(
                                          Icons.grid_view_outlined,
                                        ),
                                );
                              },
                            )
                          : Container(),
                      notesState.archiveSelected
                          ? notesState.archiveSearchOn
                              ? Container()
                              : IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    context.read<NotesBloc>().add(
                                        ArchiveSearchClickedEvent(
                                            archiveSearchOn: true));
                                  },
                                )
                          : Container(),
                      notesState.archiveSelected
                          ? BlocBuilder<NotesBloc, NotesStates>(
                              builder: (context, state) {
                                return IconButton(
                                  onPressed: () {
                                    context
                                        .read<NotesBloc>()
                                        .add(ChangeViewEvent());
                                  },
                                  icon: state.gridViewMode
                                      ? const Icon(Icons.view_agenda_outlined)
                                      : const Icon(
                                          Icons.grid_view_outlined,
                                        ),
                                );
                              },
                            )
                          : Container(),
                    ],
                  );
                },
                viewBuilder: (suggestions) {
                  return searchState is SearchInitial
                      ? Container(
                          height: height,
                          width: width,
                          color: textFieldBackgoundColor,
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
                          color: textFieldBackgoundColor,
                          child: const Center(
                            child: Icon(
                              Icons.mood,
                              color: Colors.black,
                            ),
                          ),
                        );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return <Widget>[const Icon(Icons.abc)];
                });
          },
        );
      },
    );
  }
}
