import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/addnotes_cubit/addnotes_cubit.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/pages/notes_view.dart';
import 'package:notes_app/utils/my_clipper.dart';
import 'package:notes_app/widgets/mydrawer.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../utils/my_painter.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
  });

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
          body: BlocBuilder<NotesBloc, NotesStates>(
            builder: (context, state) {
              return state.notesSelected
                  ? Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<NotesBloc, NotesStates>(
                              builder: (context, state) {
                            // if (state is NotesLoading) {
                            //   return const Center(
                            //       child:
                            //           CircularProgressIndicator.adaptive());
                            // } else {
                            //   if (state.notes.isEmpty) {
                            //     return Center(
                            //       child: MyText(
                            //         text: "No Notes Yet",
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w600,
                            //         color: Theme.of(context).primaryColor,
                            //       ),
                            //     );
                            //   } else {
                            return SafeArea(
                              child: CustomScrollView(slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  sliver: SliverAppBar(
                                    surfaceTintColor: textFieldBackgoundColor,
                                    floating: true,
                                    backgroundColor: textFieldBackgoundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    title: TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText: "Search your notes",
                                        isCollapsed: true,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        filled: true,
                                        fillColor: textFieldBackgoundColor,
                                      ),
                                    ),
                                    actions: [
                                      BlocBuilder<NotesBloc, NotesStates>(
                                        builder: (context, state) {
                                          return IconButton(
                                            onPressed: () {
                                              context
                                                  .read<NotesBloc>()
                                                  .add(ChangeViewEvent());
                                            },
                                            icon: state.gridViewMode
                                                ? const Icon(
                                                    Icons.view_agenda_outlined)
                                                : const Icon(
                                                    Icons.grid_view_outlined,
                                                  ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                NotesView(
                                  height: height,
                                  archivedNotes: false,
                                  trashNotes: false,
                                )
                              ]),
                            );
                          }),
                        ),
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
                      ? SafeArea(
                          child: CustomScrollView(slivers: [
                            NotesView(
                              height: height,
                              archivedNotes: true,
                              trashNotes: false,
                            ),
                          ]),
                        )
                      : SafeArea(
                          child: CustomScrollView(
                            slivers: [
                              NotesView(
                                height: height,
                                archivedNotes: false,
                                trashNotes: true,
                              ),
                            ],
                          ),
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
