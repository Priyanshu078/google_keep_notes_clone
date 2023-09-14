import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_event.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_states.dart';
import 'package:uuid/uuid.dart';

import '../bloc/addnotes_cubit/addnotes_cubit.dart';
import '../bloc/addnotes_cubit/addnotes_states.dart';

class AddNewWidgetPage extends StatefulWidget {
  const AddNewWidgetPage(
      {super.key, required this.isUpdate, this.note, this.index});
  final bool isUpdate;
  final Note? note;
  final int? index;

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AddNotesCubit>().pinUnpinNote();
            },
            icon: widget.isUpdate
                ? Container()
                : BlocBuilder<AddNotesCubit, AddNotesState>(
                    builder: (context, state) {
                      return state.note.pinned
                          ? const Icon(CupertinoIcons.pin_fill)
                          : const Icon(CupertinoIcons.pin);
                    },
                  ),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (widget.isUpdate) {
                Note updated = widget.note!.copyWith(
                    content: contentController.text,
                    title: titleController.text,
                    dateAdded: DateTime.now().toIso8601String(),
                    pinned: widget.note!.pinned);
              } else {
                var state = context.read<AddNotesCubit>().state;
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
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(children: [
          TextField(
            autofocus: widget.isUpdate ? false : true,
            controller: titleController,
            style: const TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "title",
                hintStyle: TextStyle(
                    fontSize: 25,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
          ),
          TextField(
            maxLines: null,
            controller: contentController,
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "content",
                hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }
}
