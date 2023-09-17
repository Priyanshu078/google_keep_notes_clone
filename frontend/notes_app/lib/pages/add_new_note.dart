import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_event.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/utils/utilities.dart';
import 'package:notes_app/widgets/mytext.dart';
import 'package:uuid/uuid.dart';
import '../bloc/addnotes_cubit/addnotes_cubit.dart';
import '../bloc/addnotes_cubit/addnotes_states.dart';
import '../constants/colors.dart';

class AddNewWidgetPage extends StatefulWidget {
  const AddNewWidgetPage({super.key, required this.isUpdate, this.note});
  final bool isUpdate;
  final Note? note;

  @override
  State<AddNewWidgetPage> createState() => _AddNewWidgetPageState();
}

class _AddNewWidgetPageState extends State<AddNewWidgetPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<AddNotesCubit, AddNotesState>(builder: (context, state) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: state.color,
          statusBarColor: state.color,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: state.color,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: state.color,
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AddNotesCubit>().pinUnpinNote();
                },
                icon: state.note.pinned
                    ? const Icon(CupertinoIcons.pin_fill)
                    : const Icon(CupertinoIcons.pin),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  var state = context.read<AddNotesCubit>().state;
                  if (titleController.text != "") {
                    if (widget.isUpdate) {
                      Note updated = state.note.copyWith(
                          content: contentController.text,
                          title: titleController.text,
                          dateAdded: DateTime.now().toIso8601String(),
                          pinned: state.note.pinned);
                      context.read<NotesBloc>().add(UpdateNote(note: updated));
                    } else {
                      Note newNote = state.note.copyWith(
                        id: const Uuid().v1(),
                        userid: "priyanshupaliwal",
                        content: contentController.text,
                        title: titleController.text,
                        dateAdded: DateTime.now().toIso8601String(),
                      );
                      context.read<NotesBloc>().add(AddNote(note: newNote));
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    Utilities().showSnackBar(
                        context, "Empty notes can not be saved!!!");
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
                    autofocus: widget.isUpdate ? false : true,
                    controller: titleController,
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                  ),
                  TextField(
                    maxLines: null,
                    controller: contentController,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Note",
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) => BlocProvider.value(
                                  value: context.read<AddNotesCubit>(),
                                  child:
                                      BlocBuilder<AddNotesCubit, AddNotesState>(
                                    builder: (context, state) {
                                      return Container(
                                        padding: const EdgeInsets.all(16.0),
                                        height: height * 0.3,
                                        width: double.infinity,
                                        color: state.color,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const MyText(
                                                text: "Color",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                            SizedBox(
                                              height: height * 0.05,
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
                                                                  .all(8.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              context
                                                                  .read<
                                                                      AddNotesCubit>()
                                                                  .setBackgroundColor(
                                                                    colors[
                                                                        index],
                                                                  );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: colors[
                                                                      index],
                                                                  shape: BoxShape
                                                                      .circle),
                                                              height:
                                                                  height * 0.1,
                                                              width:
                                                                  height * 0.1,
                                                            ),
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
                      icon: const Icon(Icons.color_lens_outlined)),
                  MyText(
                      text:
                          "Edited ${TimeOfDay.fromDateTime(DateTime.now()).format(context)}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                  IconButton(
                      onPressed: () {},
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
