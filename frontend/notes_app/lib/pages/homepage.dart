import 'package:flutter/material.dart';
import 'package:notes_app/pages/addnewnote.dart';
import 'package:notes_app/widgets/mytext.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context, listen: false)
        .fetchNotes("priyanshupaliwal");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const MyText(
            text: "Notes App",
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white),
      ),
      body: Consumer<NotesProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return value.loading
              ? const Center(child: CircularProgressIndicator())
              : value.notes.isEmpty
                  ? Center(
                      child: MyText(
                          text: "No Notes Yet",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColor),
                    )
                  : GridView.builder(
                      itemCount: value.notes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2),
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) {
                                    return AddNewWidgetPage(
                                      isUpdate: true,
                                      note: value.notes[index],
                                    );
                                  }));
                            },
                            onLongPress: () {
                              Provider.of<NotesProvider>(context, listen: false)
                                  .deleteNote(value.notes[index]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: value.notes[index].title,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyText(
                                      text: value.notes[index].content,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return const AddNewWidgetPage(
                  isUpdate: false,
                );
              }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
