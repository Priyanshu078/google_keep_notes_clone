import 'package:flutter/material.dart';
import 'package:notes_app/note.dart';
import 'package:notes_app/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (widget.isUpdate) {
                Note updated = widget.note!.copyWith(contentController.text,
                    titleController.text, DateTime.now().toString());
                Provider.of<NotesProvider>(context, listen: false)
                    .updateNote(updated);
              } else {
                Note newNote = Note(
                    id: const Uuid().v1(),
                    userid: "priyanshupaliwal",
                    content: contentController.text,
                    title: titleController.text,
                    dateAdded: DateTime.now().toIso8601String());
                await Provider.of<NotesProvider>(context, listen: false)
                    .addNewNote(newNote);
              }
              Navigator.of(context).pop();
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
