import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/search_bloc/search_event.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/utils/utilities.dart';
import 'package:notes_app/widgets/my_text_button.dart';
import 'package:notes_app/widgets/mytext.dart';
import 'package:uuid/uuid.dart';
import '../blocs and cubits/addnotes_cubit/addnotes_cubit.dart';
import '../blocs and cubits/addnotes_cubit/addnotes_states.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../constants/colors.dart';

class AddNewWidgetPage extends StatefulWidget {
  const AddNewWidgetPage({
    super.key,
    required this.isUpdate,
    required this.isArchiveUpdate,
    required this.pinnedNote,
    this.note,
    required this.isSearchUpdate,
  });
  final bool isUpdate;
  final Note? note;
  final bool isArchiveUpdate;
  final bool pinnedNote;
  final bool isSearchUpdate;

  @override
  State<AddNewWidgetPage> createState() => _AddNewWidgetPageState();
}

class _AddNewWidgetPageState extends State<AddNewWidgetPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final _utilities = Utilities();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate || widget.isArchiveUpdate) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  void showSnackBar() {
    _utilities.showSnackBar(
      context,
      "Can't edit in Trash",
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<AddNotesCubit, AddNotesState>(builder: (context, state) {
      var notesBlocState = context.read<NotesBloc>().state;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor:
              getColor(context, notesBlocState, state.colorIndex),
          statusBarColor: getColor(context, notesBlocState, state.colorIndex),
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: BlocListener<NotesBloc, NotesStates>(
          listener: (context, state) {
            if (state is NotesDeleted) {
              _utilities.showSnackBar(context, "Note Deleted !!!");
              Navigator.of(context).pop();
            } else if (state is NotesTrashed) {
              _utilities.showSnackBar(context, "Note Trashed !!!");
              Navigator.of(context).pop();
            } else if (state is NotesRestored) {
              _utilities.showSnackBar(context, "Note Restored !!!");
              Navigator.of(context).pop();
            } else if (state is NotesArchived) {
              _utilities.showSnackBar(context, "Note Archived !!!");
              Navigator.of(context).pop();
            } else if (state is NotesUnarchived) {
              _utilities.showSnackBar(context, "Note Unarchived !!!");
              Navigator.of(context).pop();
            } else if (state is NotesPinnedUnarchived) {
              _utilities.showSnackBar(context, "Note Pinned & Unarchived !!!");
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            backgroundColor:
                getColor(context, notesBlocState, state.colorIndex),
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor:
                  getColor(context, notesBlocState, state.colorIndex),
              actions: [
                state.inTrash
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          context.read<AddNotesCubit>().pinUnpinNote();
                          if (widget.isArchiveUpdate) {
                            Note note = state.note.copyWith(
                              title: titleController.text,
                              content: contentController.text,
                              dateAdded: DateTime.now().toIso8601String(),
                              archived: false,
                              pinned: true,
                              colorIndex: state.colorIndex,
                              trashed: false,
                            );
                            context.read<NotesBloc>().add(UpdateNote(
                                  note: note,
                                  fromTrash: false,
                                  fromArchive: false,
                                  forArchive: false,
                                  forUnArchive: true,
                                  pinnedUnarchive: true,
                                  homeNotePinned: widget.pinnedNote,
                                ));
                            var notesBlocState =
                                context.read<NotesBloc>().state;
                            if (widget.isSearchUpdate) {
                              context.read<SearchBloc>().add(
                                  RemoveNoteFromSearchEvent(
                                      note: note,
                                      homeSearch:
                                          notesBlocState.homeNotesSelected));
                            }
                          } else if (widget.isUpdate || widget.isSearchUpdate) {
                            // var noteState = context.read<AddNotesCubit>().state;
                            // Note updated = noteState.note.copyWith(
                            //     pinned: noteState.note.pinned,
                            //     dateAdded: DateTime.now().toIso8601String());
                            // context
                            //     .read<NotesBloc>()
                            //     .add(PinNoteEvent(note: updated));
                          }
                        },
                        icon: state.note.pinned
                            ? Icon(
                                CupertinoIcons.pin_fill,
                                color: Theme.of(context).iconTheme.color,
                              )
                            : Icon(
                                CupertinoIcons.pin,
                                color: Theme.of(context).iconTheme.color,
                              ),
                      ),
                state.inTrash
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          var notesBlocState = context.read<NotesBloc>().state;
                          if (state.inArchive) {
                            Note note = state.note.copyWith(
                              title: titleController.text,
                              content: contentController.text,
                              trashed: false,
                              archived: false,
                              pinned: false,
                              dateAdded: DateTime.now().toIso8601String(),
                              colorIndex: state.colorIndex,
                            );
                            context.read<NotesBloc>().add(UpdateNote(
                                  note: note,
                                  fromTrash: false,
                                  fromArchive: false,
                                  forArchive: false,
                                  forUnArchive: true,
                                  pinnedUnarchive: false,
                                  homeNotePinned: widget.pinnedNote,
                                ));
                            if (widget.isSearchUpdate) {
                              context
                                  .read<SearchBloc>()
                                  .add(RemoveNoteFromSearchEvent(
                                    note: note,
                                    homeSearch:
                                        notesBlocState.homeNotesSelected,
                                  ));
                            }
                          } else {
                            Note note = state.note.copyWith(
                              title: titleController.text,
                              content: contentController.text,
                              dateAdded: DateTime.now().toIso8601String(),
                              trashed: false,
                              archived: true,
                              pinned: false,
                              colorIndex: state.colorIndex,
                            );
                            context.read<NotesBloc>().add(UpdateNote(
                                  note: note,
                                  fromTrash: false,
                                  fromArchive: false,
                                  forArchive: true,
                                  forUnArchive: false,
                                  pinnedUnarchive: false,
                                  homeNotePinned: widget.pinnedNote,
                                ));
                            if (widget.isSearchUpdate) {
                              context
                                  .read<SearchBloc>()
                                  .add(RemoveNoteFromSearchEvent(
                                    note: note,
                                    homeSearch:
                                        notesBlocState.homeNotesSelected,
                                  ));
                            }
                          }
                        },
                        icon: state.inArchive
                            ? Icon(
                                Icons.unarchive_outlined,
                                color: Theme.of(context).iconTheme.color,
                              )
                            : Icon(
                                Icons.archive_outlined,
                                color: Theme.of(context).iconTheme.color,
                              )),
                state.inTrash
                    ? Container()
                    : IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () async {
                          var state = context.read<AddNotesCubit>().state;
                          var notesBlocState = context.read<NotesBloc>().state;
                          if (titleController.text != "") {
                            if (widget.isUpdate) {
                              Note updated = state.note.copyWith(
                                content: contentController.text,
                                title: titleController.text,
                                dateAdded: DateTime.now().toIso8601String(),
                                pinned: state.note.pinned,
                                colorIndex: state.colorIndex,
                              );
                              context.read<NotesBloc>().add(UpdateNote(
                                    note: updated,
                                    fromTrash: false,
                                    fromArchive: false,
                                    forArchive: false,
                                    forUnArchive: false,
                                    pinnedUnarchive: false,
                                    homeNotePinned: widget.pinnedNote,
                                  ));
                              if (widget.isSearchUpdate) {
                                context.read<SearchBloc>().add(
                                    UpdateNoteInSearchEvent(
                                        note: updated,
                                        homeSearch:
                                            notesBlocState.homeNotesSelected));
                              }
                            } else if (widget.isArchiveUpdate) {
                              Note updated = state.note.copyWith(
                                content: contentController.text,
                                title: titleController.text,
                                dateAdded: DateTime.now().toIso8601String(),
                                pinned: state.note.pinned,
                                colorIndex: state.colorIndex,
                              );
                              context.read<NotesBloc>().add(UpdateNote(
                                    note: updated,
                                    fromTrash: false,
                                    fromArchive: true,
                                    forArchive: false,
                                    forUnArchive: false,
                                    pinnedUnarchive: false,
                                    homeNotePinned: widget.pinnedNote,
                                  ));
                              if (widget.isSearchUpdate) {
                                context.read<SearchBloc>().add(
                                    UpdateNoteInSearchEvent(
                                        note: updated,
                                        homeSearch:
                                            notesBlocState.homeNotesSelected));
                              }
                            } else {
                              Note newNote = state.note.copyWith(
                                id: const Uuid().v1(),
                                userid: "priyanshupaliwal",
                                content: contentController.text,
                                title: titleController.text,
                                dateAdded: DateTime.now().toIso8601String(),
                                colorIndex: state.colorIndex,
                                pinned: state.note.pinned,
                              );
                              context
                                  .read<NotesBloc>()
                                  .add(AddNote(note: newNote));
                            }
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          } else {
                            _utilities.showSnackBar(
                              context,
                              "Empty notes can not be saved!!!",
                            );
                          }
                        },
                      )
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(children: [
                    TextField(
                      onTap: () {
                        if (state.inTrash) {
                          showSnackBar();
                        }
                      },
                      readOnly: state.inTrash,
                      autofocus: widget.isUpdate ? false : true,
                      controller: titleController,
                      style: GoogleFonts.notoSans(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                          hintStyle: GoogleFonts.notoSans(
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600)),
                    ),
                    TextField(
                      onTap: () {
                        if (state.inTrash) {
                          showSnackBar();
                        }
                      },
                      readOnly: state.inTrash,
                      maxLines: null,
                      controller: contentController,
                      style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Note",
                          hintStyle: GoogleFonts.notoSans(
                              fontSize: 16,
                              color: Colors.grey.withOpacity(1),
                              fontWeight: FontWeight.w400)),
                    ),
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: state.inTrash
                            ? null
                            : () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                          value: context.read<AddNotesCubit>(),
                                          child: BlocBuilder<AddNotesCubit,
                                              AddNotesState>(
                                            builder: (context, state) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                height: height * 0.2,
                                                width: double.infinity,
                                                color: getColor(
                                                    context,
                                                    notesBlocState,
                                                    state.colorIndex),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    MyText(
                                                      text: "Color",
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headlineMedium,
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.02,
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.1,
                                                      width: double.infinity,
                                                      child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: List.generate(
                                                            // lightMode and darkMode has same number of colors
                                                            colorsLightMode
                                                                .length,
                                                            (index) => Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      context
                                                                          .read<
                                                                              AddNotesCubit>()
                                                                          .setBackgroundColor(
                                                                            index,
                                                                          );
                                                                    },
                                                                    child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(color: getColor(context, notesBlocState, index), shape: BoxShape.circle),
                                                                            height:
                                                                                height * 0.1,
                                                                            width:
                                                                                height * 0.1,
                                                                          ),
                                                                          state.colorIndex == index
                                                                              ? Container(
                                                                                  decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.blue), shape: BoxShape.circle),
                                                                                  height: height * 0.1,
                                                                                  width: height * 0.1,
                                                                                  child: const Center(
                                                                                      child: Icon(
                                                                                    Icons.check,
                                                                                    size: 30,
                                                                                    color: Colors.blue,
                                                                                  )),
                                                                                )
                                                                              : Container()
                                                                        ]),
                                                                  ),
                                                                )).toList(),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ));
                              },
                        icon: Icon(
                          Icons.color_lens_outlined,
                          color: Theme.of(context).iconTheme.color,
                        )),
                    MyText(
                      text:
                          "Edited ${TimeOfDay.fromDateTime(DateTime.now()).format(context)}",
                      textStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value: context.read<AddNotesCubit>(),
                                      ),
                                    ],
                                    child: BlocBuilder<AddNotesCubit,
                                        AddNotesState>(
                                      builder: (context, state) {
                                        return Container(
                                          color: getColor(context,
                                              notesBlocState, state.colorIndex),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          height: state.inTrash
                                              ? height * 0.2
                                              : height * 0.15,
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              state.inTrash
                                                  ? ListTile(
                                                      horizontalTitleGap: 0,
                                                      onTap: () {
                                                        Note note = state.note
                                                            .copyWith(
                                                                pinned: false,
                                                                trashed: false,
                                                                dateAdded: DateTime
                                                                        .now()
                                                                    .toIso8601String());
                                                        context
                                                            .read<NotesBloc>()
                                                            .add(UpdateNote(
                                                              note: note,
                                                              fromTrash: true,
                                                              fromArchive:
                                                                  false,
                                                              forArchive: false,
                                                              forUnArchive:
                                                                  false,
                                                              pinnedUnarchive:
                                                                  false,
                                                              homeNotePinned:
                                                                  widget
                                                                      .pinnedNote,
                                                            ));
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      leading: const Icon(
                                                          Icons.restore),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 8.0),
                                                        child: MyText(
                                                          text: "Restore",
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              ListTile(
                                                horizontalTitleGap: 0,
                                                onTap: () async {
                                                  if (state
                                                      .note.title.isNotEmpty) {
                                                    if (state.inTrash) {
                                                      await showDialog(
                                                          context: context,
                                                          builder:
                                                              (_) =>
                                                                  AlertDialog(
                                                                    backgroundColor:
                                                                        textFieldBackgroundColor,
                                                                    title:
                                                                        MyText(
                                                                      text:
                                                                          "Delete this note forever",
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayMedium,
                                                                    ),
                                                                    actions: [
                                                                      MyTextButton(
                                                                          text:
                                                                              "Cancel",
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          }),
                                                                      MyTextButton(
                                                                          text:
                                                                              "Delete",
                                                                          onPressed:
                                                                              () {
                                                                            context.read<NotesBloc>().add(DeleteNote(fromSelectedNotes: false, noteslist: <Note>[
                                                                                  state.note
                                                                                ]));
                                                                            Navigator.of(context).pop();
                                                                          })
                                                                    ],
                                                                  ));
                                                    } else {
                                                      context
                                                          .read<NotesBloc>()
                                                          .add(TrashNote(
                                                              note: state.note,
                                                              addNotesPage:
                                                                  true,
                                                              fromArchive: widget
                                                                  .isArchiveUpdate));
                                                      var notesBlocState =
                                                          context
                                                              .read<NotesBloc>()
                                                              .state;
                                                      if (widget
                                                          .isSearchUpdate) {
                                                        context
                                                            .read<SearchBloc>()
                                                            .add(RemoveNoteFromSearchEvent(
                                                                note:
                                                                    state.note,
                                                                homeSearch:
                                                                    notesBlocState
                                                                        .homeNotesSelected));
                                                      }
                                                    }
                                                  } else {
                                                    _utilities.showSnackBar(
                                                      context,
                                                      "Empty Note can not be deleted !!!",
                                                    );
                                                  }
                                                  if (mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                leading: Icon(state.inTrash
                                                    ? Icons
                                                        .delete_forever_outlined
                                                    : Icons.delete_outline),
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: MyText(
                                                    text: state.inTrash
                                                        ? "Delete forever"
                                                        : "Delete",
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ));
                        },
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.more_vert_outlined))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
