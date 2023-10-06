import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/addnotes_cubit/addnotes_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/pages/notes_view_trash_archived.dart';
import 'package:notes_app/pages/search_notes_page.dart';
import 'package:notes_app/utils/my_clipper.dart';
import 'package:notes_app/widgets/mydrawer.dart';
import 'package:notes_app/widgets/mytext.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../utils/my_painter.dart';
import '../widgets/my_text_button.dart';
import 'notes_view_home.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final focusNode = FocusNode();
  final SearchController searchController = SearchController();
  final GlobalKey searchBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        var state = context.read<NotesBloc>().state;
        if (state.notesSelected) {
          if (state.homeSearchOn) {
            context
                .read<NotesBloc>()
                .add(HomeSearchClickedEvent(homeSearchOn: false));
            return false;
          } else {
            return true;
          }
        } else if (state.archiveSelected) {
          if (state.archiveSearchOn) {
            context
                .read<NotesBloc>()
                .add(ArchiveSearchClickedEvent(archiveSearchOn: false));
            return false;
          } else {
            return true;
          }
        }
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: bottomBannerColor,
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: BlocBuilder<NotesBloc, NotesStates>(
              builder: (context, state) {
                return state.homeSearchOn
                    ? SearchNotesPage(
                        height: height,
                        width: width,
                      )
                    : state.notesSelected
                        ? Stack(
                            children: [
                              BlocBuilder<NotesBloc, NotesStates>(
                                  builder: (context, state) {
                                return SafeArea(
                                    child: CustomScrollView(slivers: [
                                  SliverPadding(
                                    padding: const EdgeInsets.all(8.0),
                                    sliver: SliverAppBar(
                                      automaticallyImplyLeading: false,
                                      floating: true,
                                      flexibleSpace: SearchAnchor(
                                          viewLeading: IconButton(
                                              onPressed: () {
                                                searchController.closeView("");
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              },
                                              icon:
                                                  const Icon(Icons.arrow_back)),
                                          searchController: searchController,
                                          isFullScreen: true,
                                          builder: (BuildContext context,
                                              SearchController controller) {
                                            return SearchBar(
                                              key: searchBarKey,
                                              padding:
                                                  const MaterialStatePropertyAll<
                                                      EdgeInsets>(
                                                EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                ),
                                              ),
                                              hintText: "Search your notes",
                                              hintStyle:
                                                  const MaterialStatePropertyAll(
                                                      TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Colors.black54)),
                                              leading: IconButton(
                                                icon: const Icon(Icons.menu),
                                                onPressed: () {
                                                  _scaffoldKey.currentState!
                                                      .openDrawer();
                                                },
                                              ),
                                              focusNode: focusNode,
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50))),
                                              controller: controller,
                                              onTap: () {
                                                controller.openView();
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode);
                                              },
                                              trailing: [
                                                BlocBuilder<NotesBloc,
                                                    NotesStates>(
                                                  builder: (context, state) {
                                                    return IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<NotesBloc>()
                                                            .add(
                                                                ChangeViewEvent());
                                                      },
                                                      icon: state.gridViewMode
                                                          ? const Icon(Icons
                                                              .view_agenda_outlined)
                                                          : const Icon(
                                                              Icons
                                                                  .grid_view_outlined,
                                                            ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                          viewBuilder: (suggestions) {
                                            return Container(
                                              height: height,
                                              width: width,
                                              color: textFieldBackgoundColor,
                                              child: const Center(
                                                  child: Icon(
                                                Icons.mood,
                                                color: Colors.black,
                                              )),
                                            );
                                          },
                                          suggestionsBuilder:
                                              (BuildContext context,
                                                  SearchController controller) {
                                            return <Widget>[
                                              const Icon(Icons.abc)
                                            ];
                                          }),
                                      // ),
                                      // InkWell(
                                      //   radius: 50,
                                      //   onTap: () {
                                      //     context.read<NotesBloc>().add(
                                      //         HomeSearchClickedEvent(
                                      //             homeSearchOn: true));
                                      //   },
                                      //   child: Transform.translate(
                                      //     offset: const Offset(-30, -1),
                                      //     child: const Align(
                                      //       alignment: Alignment.center,
                                      //       child: MyText(
                                      //           text: "Search your notes",
                                      //           fontSize: 16,
                                      //           fontWeight: FontWeight.normal,
                                      //           color: Colors.black54),
                                      //     ),
                                      //   ),
                                      // ),
                                      // title: const MyText(
                                      //     text: "Search your notes",
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.normal,
                                      //     color: Colors.black54),
                                      // TextField(
                                      //   controller: searchController,
                                      //   textAlignVertical:
                                      //       TextAlignVertical.center,
                                      //   decoration: InputDecoration(
                                      //     hintText: "Search your notes",
                                      //     isCollapsed: true,
                                      //     border: OutlineInputBorder(
                                      //         borderSide: BorderSide.none,
                                      //         borderRadius:
                                      //             BorderRadius.circular(30)),
                                      //     filled: true,
                                      //     fillColor: textFieldBackgoundColor,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    sliver: NotesViewHome(
                                      height: height,
                                      scaffoldKey: _scaffoldKey,
                                    ),
                                  )
                                ]));
                              }),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Stack(children: [
                                  ClipPath(
                                    clipper:
                                        MyClipper(height: height, width: width),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: bottomBannerColor,
                                      ),
                                      height: height * 0.055,
                                      width: width,
                                    ),
                                  ),
                                  CustomPaint(
                                    painter: MyPainter(),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      height: height * 0.055,
                                      width: width,
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          )
                        : SafeArea(
                            child: CustomScrollView(slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.all(8.0),
                                sliver: SliverAppBar(
                                  flexibleSpace: SearchAnchor(
                                      viewLeading: IconButton(
                                          onPressed: () {
                                            searchController.closeView("");
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          },
                                          icon: const Icon(Icons.arrow_back)),
                                      searchController: searchController,
                                      isFullScreen: true,
                                      builder: (BuildContext context,
                                          SearchController controller) {
                                        return SearchBar(
                                          key: searchBarKey,
                                          padding:
                                              const MaterialStatePropertyAll<
                                                  EdgeInsets>(
                                            EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                            ),
                                          ),
                                          hintText: "Search your notes",
                                          hintStyle:
                                              const MaterialStatePropertyAll(
                                                  TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black54)),
                                          leading: IconButton(
                                            icon: const Icon(Icons.menu),
                                            onPressed: () {
                                              _scaffoldKey.currentState!
                                                  .openDrawer();
                                            },
                                          ),
                                          focusNode: focusNode,
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50))),
                                          controller: controller,
                                          onTap: () {
                                            controller.openView();
                                            FocusScope.of(context)
                                                .requestFocus(focusNode);
                                          },
                                          trailing: [
                                            state.archiveSelected
                                                ? state.archiveSearchOn
                                                    ? Container()
                                                    : IconButton(
                                                        icon: const Icon(
                                                            Icons.search),
                                                        onPressed: () {
                                                          context
                                                              .read<NotesBloc>()
                                                              .add(ArchiveSearchClickedEvent(
                                                                  archiveSearchOn:
                                                                      true));
                                                        },
                                                      )
                                                : Container(),
                                            state.archiveSelected
                                                ? BlocBuilder<NotesBloc,
                                                    NotesStates>(
                                                    builder: (context, state) {
                                                      return IconButton(
                                                        onPressed: () {
                                                          context
                                                              .read<NotesBloc>()
                                                              .add(
                                                                  ChangeViewEvent());
                                                        },
                                                        icon: state.gridViewMode
                                                            ? const Icon(Icons
                                                                .view_agenda_outlined)
                                                            : const Icon(
                                                                Icons
                                                                    .grid_view_outlined,
                                                              ),
                                                      );
                                                    },
                                                  )
                                                : Container(),
                                            (state.trashSelected &&
                                                    state.trashNotes.isNotEmpty)
                                                ? IconButton(
                                                    onPressed: () {
                                                      showMenu(
                                                          color:
                                                              textFieldBackgoundColor,
                                                          context: context,
                                                          position:
                                                              const RelativeRect
                                                                  .fromLTRB(100,
                                                                  0, 0, 100),
                                                          items: <PopupMenuEntry>[
                                                            PopupMenuItem(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (_) =>
                                                                        AlertDialog(
                                                                          title: const MyText(
                                                                              text: "Empty Trash?",
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                          content: const MyText(
                                                                              text: "All notes in Trash will be permanently deleted.",
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black),
                                                                          actions: [
                                                                            MyTextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              text: "Cancel",
                                                                            ),
                                                                            MyTextButton(
                                                                              onPressed: () {
                                                                                context.read<NotesBloc>().add(EmptyTrashEvent());
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              text: "Empty Trash",
                                                                            ),
                                                                          ],
                                                                        ));
                                                              },
                                                              child:
                                                                  const MyText(
                                                                text:
                                                                    "Empty Trash",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )
                                                          ]);
                                                    },
                                                    icon: const Icon(Icons
                                                        .more_vert_outlined),
                                                  )
                                                : Container()
                                          ],
                                        );
                                      },
                                      viewBuilder: (suggestions) {
                                        return Container(
                                          height: height,
                                          width: width,
                                          color: textFieldBackgoundColor,
                                          child: const Center(
                                              child: Icon(
                                            Icons.mood,
                                            color: Colors.black,
                                          )),
                                        );
                                      },
                                      suggestionsBuilder: (BuildContext context,
                                          SearchController controller) {
                                        return <Widget>[const Icon(Icons.abc)];
                                      }),
                                  // surfaceTintColor: textFieldBackgoundColor,
                                  // floating: true,
                                  // backgroundColor: textFieldBackgoundColor,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(30)),
                                  // title: state.archiveSearchOn
                                  //     ? const MyText(
                                  //         text: "Search your notes",
                                  //         fontSize: 16,
                                  //         fontWeight: FontWeight.normal,
                                  //         color: Colors.black54)
                                  // ? TextField(
                                  //     controller: searchController,
                                  //     textAlignVertical:
                                  //         TextAlignVertical.center,
                                  //     decoration: InputDecoration(
                                  //       hintText: "Search your notes",
                                  //       isCollapsed: true,
                                  //       border: OutlineInputBorder(
                                  //           borderSide: BorderSide.none,
                                  //           borderRadius:
                                  //               BorderRadius.circular(30)),
                                  //       filled: true,
                                  //       fillColor: textFieldBackgoundColor,
                                  //     ),
                                  //   )
                                  // : MyText(
                                  //     text: state.archiveSelected
                                  //         ? "Archive"
                                  //         : "Trash",
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.normal,
                                  //     color: Colors.black,
                                  //   ),
                                ),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                sliver: NotesViewTrashArchived(
                                  height: height,
                                  inArchivedNotes: state.archiveSelected,
                                  inTrashedNotes: state.trashSelected,
                                ),
                              ),
                            ]),
                          );
              },
            ),
            drawer: MyDrawer(
              height: height,
              width: width,
              scaffoldKey: _scaffoldKey,
            ),
            floatingActionButton: BlocBuilder<NotesBloc, NotesStates>(
              builder: (context, state) {
                return state.notesSelected
                    ? Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8.0, right: 16.0),
                        child: FloatingActionButton(
                          backgroundColor: bottomBannerColor,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) {
                                  return MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => AddNotesCubit(),
                                      ),
                                      BlocProvider.value(
                                        value: context.read<NotesBloc>(),
                                      ),
                                    ],
                                    child: const AddNewWidgetPage(
                                      isUpdate: false,
                                      isArchiveUpdate: false,
                                      pinnedNote: false,
                                    ),
                                  );
                                }));
                          },
                          tooltip: 'Increment',
                          child: const Icon(
                            Icons.add,
                            size: 35,
                          ),
                        ),
                      )
                    : Container();
              },
            )),
      ),
    );
  }
}
