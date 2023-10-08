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
  });
  final bool isUpdate;
  final Note? note;
  final bool isArchiveUpdate;
  final bool pinnedNote;

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
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: colors[state.colorIndex],
          statusBarColor: colors[state.colorIndex],
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
            backgroundColor: colors[state.colorIndex],
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: colors[state.colorIndex],
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
                          }
                        },
                        icon: state.note.pinned
                            ? const Icon(CupertinoIcons.pin_fill)
                            : const Icon(CupertinoIcons.pin),
                      ),
                state.inTrash
                    ? Container()
                    : IconButton(
                        onPressed: () {
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
                          } else {
                            Note note = state.note.copyWith(
                              title: titleController.text,
                              content: contentController.text,
                              dateAdded: DateTime.now().toIso8601String(),
                              trashed: false,
                              archived: true,
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
                            context
                                .read<SearchBloc>()
                                .add(RemoveNoteFromSearchEvent(note: note));
                          }
                        },
                        icon: state.inArchive
                            ? const Icon(Icons.unarchive_outlined)
                            : const Icon(Icons.archive_outlined)),
                state.inTrash
                    ? Container()
                    : IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () async {
                          var state = context.read<AddNotesCubit>().state;
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
                              context
                                  .read<SearchBloc>()
                                  .add(UpdateNoteInSearchEvent(note: updated));
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
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500)),
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
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Note",
                          hintStyle: GoogleFonts.poppins(
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
                                                color: colors[state.colorIndex],
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const MyText(
                                                        text: "Color",
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
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
                                                            colors.length,
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
                                                                                BoxDecoration(color: colors[index], shape: BoxShape.circle),
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
                          color: state.inTrash ? Colors.black26 : Colors.black,
                        )),
                    MyText(
                        text:
                            "Edited ${TimeOfDay.fromDateTime(DateTime.now()).format(context)}",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
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
                                          color: colors[state.colorIndex],
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
                                                      title: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0),
                                                        child: MyText(
                                                            text: "Restore",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.black),
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
                                                                        textFieldBackgoundColor,
                                                                    title: const MyText(
                                                                        text:
                                                                            "Delete this note forever",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .black),
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
                                                                            context.read<NotesBloc>().add(DeleteNote(note: state.note));
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
                                                                  true));
                                                      context
                                                          .read<SearchBloc>()
                                                          .add(
                                                              RemoveNoteFromSearchEvent(
                                                                  note: state
                                                                      .note));
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
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ));
                        },
                        color: Colors.black,
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
