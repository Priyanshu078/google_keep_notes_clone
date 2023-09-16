import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/addnotes_cubit/addnotes_cubit.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/widgets/mytext.dart';

import '../bloc/notes_bloc/notes_bloc.dart';
import '../bloc/notes_bloc/notes_states.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });
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
          child: BlocBuilder<NotesBloc, NotesStates>(builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              if (state.notes.isEmpty) {
                return Center(
                  child: MyText(
                    text: "No Notes Yet",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else {
                return GridView.builder(
                  itemCount: state.notes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2),
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (_) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<NotesBloc>(),
                                    ),
                                    BlocProvider(
                                        create: (context) => AddNotesCubit()
                                          ..setNoteData(state.notes[index]))
                                  ],
                                  child: AddNewWidgetPage(
                                    isUpdate: true,
                                    note: state.notes[index],
                                  ),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  maxLines: 4,
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
              }
            }
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<NotesBloc>(),
                      ),
                      BlocProvider(
                        create: (context) => AddNotesCubit(),
                      ),
                    ],
                    child: const AddNewWidgetPage(
                      isUpdate: false,
                    ),
                  );
                }));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
