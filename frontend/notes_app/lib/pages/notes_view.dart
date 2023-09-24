import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/pages/add_new_note.dart';

import '../blocs and cubits/addnotes_cubit/addnotes_cubit.dart';
import '../blocs and cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_event.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../constants/colors.dart';
import '../widgets/mytext.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key, required this.height});

  final double height;

  void moveToUpdatePage(BuildContext context, int index) {
    var state = context.read<NotesBloc>().state;
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<NotesBloc>(),
              ),
              BlocProvider(
                  create: (context) =>
                      AddNotesCubit()..setNoteData(state.notes[index]))
            ],
            child: AddNewWidgetPage(
              isUpdate: true,
              note: state.notes[index],
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    var state = context.read<NotesBloc>().state;
    return state is NotesLoading
        ? SliverList(
            delegate: SliverChildListDelegate.fixed([
              SizedBox(
                height: height * 0.75,
                width: double.infinity,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ]),
          )
        : state.notes.isEmpty
            ? SliverList(
                delegate: SliverChildListDelegate.fixed([
                  SizedBox(
                      height: height * 0.75,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.amber,
                            size: 130,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          const MyText(
                            text: "Notes you add appear here",
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          )
                        ],
                      ))
                ]),
              )
            : state.gridViewMode
                ? SliverGrid.builder(
                    itemCount: state.notes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: ((_, index) {
                      return Padding(
                        padding: (state.notes.length % 2 == 0)
                            ? ((index == state.notes.length - 1) ||
                                    (index == state.notes.length - 2))
                                ? EdgeInsets.only(bottom: height * 0.06)
                                : const EdgeInsets.all(0)
                            : (index == state.notes.length - 1)
                                ? EdgeInsets.only(bottom: height * 0.06)
                                : const EdgeInsets.all(0),
                        child: GestureDetector(
                          onTap: () {
                            moveToUpdatePage(context, index);
                          },
                          onLongPress: () {
                            context.read<NotesBloc>().add(DeleteNote(
                                note: state.notes[index], addNotesPage: false));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: colors[state.notes[index].colorIndex],
                                border: state.notes[index].colorIndex == 0
                                    ? Border.all(color: Colors.grey)
                                    : null,
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
                                  SizedBox(
                                    height: height * 0.005,
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
                  )
                : SliverList.builder(
                    itemCount: state.notes.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: (index == state.notes.length - 1)
                            ? EdgeInsets.only(top: 8.0, bottom: height * 0.06)
                            : EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                        child: GestureDetector(
                          onTap: () {
                            moveToUpdatePage(context, index);
                          },
                          onLongPress: () {
                            context.read<NotesBloc>().add(DeleteNote(
                                note: state.notes[index], addNotesPage: false));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: colors[state.notes[index].colorIndex],
                                border: state.notes[index].colorIndex == 0
                                    ? Border.all(color: Colors.grey)
                                    : null,
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
                                  SizedBox(
                                    height: height * 0.005,
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
