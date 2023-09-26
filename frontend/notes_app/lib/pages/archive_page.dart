import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs%20and%20cubits/notes_bloc/notes_bloc.dart';
import '../blocs and cubits/notes_bloc/notes_states.dart';
import '../widgets/mytext.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key, required this.height});
  final double height;
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
                            Icons.archive_outlined,
                            color: Colors.amber,
                            size: 130,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          const MyText(
                            text: "Your archived notes appear here",
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          )
                        ],
                      ))
                ]),
              )
            : Container();
    // : NotesView(height: height);
  }
}
