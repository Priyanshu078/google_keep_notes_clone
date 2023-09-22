import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/addnotes_cubit/addnotes_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/utils/my_clipper.dart';
import 'package:notes_app/widgets/mydrawer.dart';
import 'package:notes_app/widgets/mytext.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../utils/my_painter.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
  });

  void moveToUpdatePage(BuildContext context, int index) {
    var state = context.read<NotesBloc>().state;
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<NotesBloc>(),
              ),
              BlocProvider(
                  create: (context) =>
                      AddNotesCubit()..setNoteData(state.notes[index]))
            ],
            child: AddNewWidgetPage(
              isUpdate: true,
              note: state.notes[index],
            ),
          );
        }));
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: bottomBannerColor,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size(
                AppBar().preferredSize.width,
                AppBar().preferredSize.height + height * 0.01,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    16, AppBar().preferredSize.height * 0.5, 16, 0),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Search your notes",
                    suffixIcon: BlocBuilder<NotesBloc, NotesStates>(
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
                    prefixIcon: IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu)),
                    isCollapsed: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)),
                    filled: true,
                    fillColor: textFieldBackgoundColor,
                  ),
                ),
              )),
          body: BlocBuilder<NotesBloc, NotesStates>(
            builder: (context, state) {
              return state.notesSelected
                  ? Stack(
                      children: [
                        BlocBuilder<NotesBloc, NotesStates>(
                            builder: (context, state) {
                          if (state is NotesLoading) {
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          } else {
                            if (state.notes.isEmpty) {
                              return Center(
                                child: MyText(
                                  text: "No Notes Yet",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              );
                            } else {
                              if (state.gridViewMode) {
                                return GridView.builder(
                                  itemCount: state.notes.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: (state.notes.length % 2 == 0)
                                          ? ((index ==
                                                      state.notes.length - 1) ||
                                                  (index ==
                                                      state.notes.length - 2))
                                              ? EdgeInsets.fromLTRB(
                                                  8.0, 8.0, 8.0, height * 0.07)
                                              : const EdgeInsets.all(8.0)
                                          : (index == state.notes.length - 1)
                                              ? EdgeInsets.fromLTRB(
                                                  8.0, 8.0, 8.0, height * 0.07)
                                              : const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          moveToUpdatePage(context, index);
                                        },
                                        onLongPress: () {
                                          context.read<NotesBloc>().add(
                                              DeleteNote(
                                                  note: state.notes[index],
                                                  addNotesPage: false));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: colors[state
                                                  .notes[index].colorIndex],
                                              border: state.notes[index]
                                                          .colorIndex ==
                                                      0
                                                  ? Border.all(
                                                      color: Colors.grey)
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: state
                                                        .notes[index].title,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                SizedBox(
                                                  height: height * 0.005,
                                                ),
                                                MyText(
                                                  text: state
                                                      .notes[index].content,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: state.notes.length,
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding: (index ==
                                                state.notes.length - 1)
                                            ? EdgeInsets.fromLTRB(
                                                8.0, 8.0, 8.0, height * 0.07)
                                            : const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            moveToUpdatePage(context, index);
                                          },
                                          onLongPress: () {
                                            context.read<NotesBloc>().add(
                                                DeleteNote(
                                                    note: state.notes[index],
                                                    addNotesPage: false));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: colors[state
                                                    .notes[index].colorIndex],
                                                border: state.notes[index]
                                                            .colorIndex ==
                                                        0
                                                    ? Border.all(
                                                        color: Colors.grey)
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  MyText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: state
                                                          .notes[index].title,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  MyText(
                                                    text: state
                                                        .notes[index].content,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }));
                              }
                            }
                          }
                        }),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Stack(children: [
                            ClipPath(
                              clipper: MyClipper(height: height, width: width),
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
                  : state.archiveSelected
                      ? const Center(
                          child: MyText(
                              text: "Archive Selected",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      : const Center(
                          child: MyText(
                              text: "Trash Selected",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
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
                      padding: const EdgeInsets.only(bottom: 8.0, right: 16.0),
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
    );
  }
}
