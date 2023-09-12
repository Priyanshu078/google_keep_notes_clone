import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
              // context.read<NotesProvider>().setPinned(widget.index);
            },
            icon: widget.isUpdate
                ? widget.note!.pinned
                    ? const Icon(CupertinoIcons.pin_fill)
                    : const Icon(CupertinoIcons.pin)
                : Consumer<NotesProvider>(builder: (context, value, child) {
                    return value.notes[widget.index!].pinned
                        ? const Icon(CupertinoIcons.pin_fill)
                        : const Icon(CupertinoIcons.pin);
                  }),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (widget.isUpdate) {
                Note updated = widget.note!.copyWith(
                    contentController.text,
                    titleController.text,
                    DateTime.now().toIso8601String(),
                    widget.note!.pinned);
                Provider.of<NotesProvider>(context, listen: false)
                    .updateNote(updated);
              } else {
                Note newNote = Note(
                    id: const Uuid().v1(),
                    userid: "priyanshupaliwal",
                    content: contentController.text,
                    title: titleController.text,
                    dateAdded: DateTime.now().toIso8601String(),
                    pinned: false);
                await Provider.of<NotesProvider>(context, listen: false)
                    .addNewNote(newNote);
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
