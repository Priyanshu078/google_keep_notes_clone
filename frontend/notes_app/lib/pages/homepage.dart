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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final focusNode = FocusNode();

  final SearchController controller1 = SearchController();

  final SearchController controller2 = SearchController();

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
            FocusScope.of(context).requestFocus(FocusNode());
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
                return state.notesSelected
                    ? Stack(
                        children: [
                          BlocBuilder<NotesBloc, NotesStates>(
                              builder: (context, state) {
                            return SafeArea(
                                child: CustomScrollView(slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.all(8.0),
                                sliver: SliverAppBar(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    automaticallyImplyLeading: false,
                                    floating: true,
                                    flexibleSpace: SearchNotesPage(
                                      height: height,
                                      width: width,
                                      controller: controller1,
                                      focusNode: focusNode,
                                      scaffoldKey: _scaffoldKey,
                                    )
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
                            padding: state.trashSelected
                                ? EdgeInsets.zero
                                : const EdgeInsets.all(8.0),
                            sliver: SliverAppBar(
                              title: state.trashSelected
                                  ? const MyText(
                                      text: "Trash",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)
                                  : Container(),
                              shape: state.trashSelected
                                  ? const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                              automaticallyImplyLeading:
                                  state.trashSelected ? true : false,
                              floating: true,
                              flexibleSpace: state.trashSelected
                                  ? Container()
                                  : SearchNotesPage(
                                      height: height,
                                      width: width,
                                      controller: controller2,
                                      focusNode: focusNode,
                                      scaffoldKey: _scaffoldKey,
                                    ),
                              surfaceTintColor: state.trashSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              backgroundColor: state.trashSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              actions: [
                                (state.trashSelected &&
                                        state.trashNotes.isNotEmpty)
                                    ? IconButton(
                                        onPressed: () {
                                          showMenu(
                                              color: textFieldBackgoundColor,
                                              context: context,
                                              position:
                                                  const RelativeRect.fromLTRB(
                                                      100, 0, 0, 100),
                                              items: <PopupMenuEntry>[
                                                PopupMenuItem(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (_) => AlertDialog(
                                                                  title: const MyText(
                                                                      text:
                                                                          "Empty Trash?",
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black),
                                                                  content: const MyText(
                                                                      text:
                                                                          "All notes in Trash will be permanently deleted.",
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Colors
                                                                          .black),
                                                                  actions: [
                                                                    MyTextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      text:
                                                                          "Cancel",
                                                                    ),
                                                                    MyTextButton(
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .read<NotesBloc>()
                                                                            .add(EmptyTrashEvent());
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      text:
                                                                          "Empty Trash",
                                                                    ),
                                                                  ],
                                                                ));
                                                  },
                                                  child: const MyText(
                                                    text: "Empty Trash",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ]);
                                        },
                                        icon: const Icon(
                                            Icons.more_vert_outlined),
                                      )
                                    : Container()
                              ],
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
                            padding: state.trashSelected
                                ? const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0)
                                : const EdgeInsets.all(8.0),
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
