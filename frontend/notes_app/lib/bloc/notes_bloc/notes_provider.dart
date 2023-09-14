import 'package:flutter/material.dart';
import 'package:notes_app/api/api_service.dart';
import 'package:notes_app/data/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> notes = [];
  final ApiService _apiService = ApiService();

  void fetchNotes(String userid) async {
    notifyListeners();
  }

  Future<void> addNewNote(Note note) async {
    await _apiService.addNotes(note);
    notes.add(note);
    sortNotes();
    notifyListeners();
  }

  sortNotes() {
    notes.sort((a, b) =>
        DateTime.parse(b.dateAdded).compareTo(DateTime.parse(a.dateAdded)));
  }

  void updateNote(Note note) async {
    int index =
        notes.indexOf(notes.firstWhere((element) => (element.id == note.id)));
    notes[index] = notes[index]
        .copyWith(note.content, note.title, note.dateAdded, note.pinned);
    await _apiService.updateNotes(note);
    sortNotes();
    notifyListeners();
  }

  void deleteNote(Note note) async {
    int index =
        notes.indexOf(notes.firstWhere((element) => (element.id == note.id)));
    notes.removeAt(index);
    await _apiService.deleteNotes(note);
    notifyListeners();
  }
}
