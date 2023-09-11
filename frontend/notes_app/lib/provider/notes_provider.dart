import 'package:flutter/material.dart';
import 'package:notes_app/api/api_service.dart';
import 'package:notes_app/data/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> notes = [];
  bool loading = true;
  final ApiService _apiService = ApiService();

  void fetchNotes(String userid) async {
    notes = await _apiService.getNotes(userid);
    loading = false;
    notifyListeners();
  }

  Future<void> addNewNote(Note note) async {
    await _apiService.addNotes(note);
    notes.add(note);
    notifyListeners();
  }

  void updateNote(Note note) async {
    int index =
        notes.indexOf(notes.firstWhere((element) => (element.id == note.id)));
    notes[index] =
        notes[index].copyWith(note.content, note.title, note.dateAdded);
    await _apiService.updateNotes(note);
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
