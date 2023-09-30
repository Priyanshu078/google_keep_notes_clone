import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_event.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import 'package:notes_app/utils/utilities.dart';
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
    this.note,
  });
  final bool isUpdate;
  final Note? note;

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
    if (widget.isUpdate) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  void showSnackBar() {
    _utilities.showSnackBar(context, "Can't edit in Trash", true, () {});
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
                      },
                      icon: state.note.pinned
                          ? const Icon(CupertinoIcons.pin_fill)
                          : const Icon(CupertinoIcons.pin),
                    ),
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
                                dateAdded: DateTime.now().toString(),
                                pinned: state.note.pinned);
                            context
                                .read<NotesBloc>()
                                .add(UpdateNote(note: updated));
                          } else {
                            Note newNote = state.note.copyWith(
                              id: const Uuid().v1(),
                              userid: "priyanshupaliwal",
                              content: contentController.text,
                              title: titleController.text,
                              dateAdded: DateTime.now().toString(),
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
                          _utilities.showSnackBar(context,
                              "Empty notes can not be saved!!!", false, null);
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
                                                                          decoration: BoxDecoration(
                                                                              color: colors[index],
                                                                              shape: BoxShape.circle),
                                                                          height:
                                                                              height * 0.1,
                                                                          width:
                                                                              height * 0.1,
                                                                        ),
                                                                        state.colorIndex ==
                                                                                index
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
                      icon: const Icon(
                        Icons.color_lens_outlined,
                        color: Colors.black,
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
                                    BlocProvider.value(
                                      value: context.read<NotesBloc>(),
                                    ),
                                  ],
                                  child: BlocListener<NotesBloc, NotesStates>(
                                    listener: (context, state) {
                                      if (state is NotesDeleted) {
                                        Navigator.of(context).pop();
                                        _utilities.showSnackBar(context,
                                            "Note Deleted !!!", false, null);
                                      }
                                    },
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
                                                onTap: () {
                                                  if (state
                                                      .note.title.isNotEmpty) {
                                                    context
                                                        .read<NotesBloc>()
                                                        .add(DeleteNote(
                                                            note: state.note,
                                                            addNotesPage:
                                                                true));
                                                  } else {
                                                    _utilities.showSnackBar(
                                                        context,
                                                        "Empty Note can not be deleted !!!",
                                                        false,
                                                        null);
                                                  }
                                                  Navigator.of(context).pop();
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
      );
    });
  }
}
