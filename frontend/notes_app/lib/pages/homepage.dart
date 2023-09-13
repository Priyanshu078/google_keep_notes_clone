import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/pages/addnewnote.dart';
import 'package:notes_app/widgets/mytext.dart';

import '../notes_bloc/notes_bloc.dart';
import '../notes_bloc/notes_states.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const MyText(
              text: "Notes App",
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<NotesBloc, NotesStates>(
            builder: (context, state) {
              return GridView.builder(
                itemCount: state.notes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 2),
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
                                note: state.notes[index],
                                index: index,
                              );
                            }));
                      },
                      onLongPress: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.5),
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
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
                                  text: state.notes[index].title,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              const SizedBox(
                                height: 10,
                              ),
                              MyText(
                                text: state.notes[index].content,
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
        ));
  }
}
