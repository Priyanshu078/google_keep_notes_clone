import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/data/note.dart';

class ApiService {
  String baseUrl = "http://192.168.43.123:3000/api";
  final dio = Dio();

  Future<List<Note>> getNotes(String userid) async {
    String endPoint = '/getNotes';
    String url = baseUrl + endPoint;
    List<Note> notes = [];
    debugPrint(userid);
    var response = await dio.post(url, data: {"userid": userid});
    List data = response.data;
    for (int i = 0; i < data.length; i++) {
      notes.add(Note(
          id: data[i]['id'],
          userid: data[i]['userid'],
          content: data[i]['content'],
          title: data[i]['title'],
          dateAdded: data[i]['dateadded'],
          pinned: data[i]["pinned"],
          colorIndex: data[i]["colorIndex"]));
    }
    return notes;
  }

  Future<void> addNotes(Note note) async {
    String endPoint = '/addNotes';
    String url = baseUrl + endPoint;
    var response = await dio.post(url, data: {
      "id": note.id,
      "userid": note.userid,
      "title": note.title,
      "content": note.content,
      "pinned": note.pinned,
      "colorIndex": note.colorIndex,
    });
    debugPrint(response.data.toString());
  }

  Future<void> deleteNotes(Note note) async {
    String endPoint = '/deleteNotes';
    String url = baseUrl + endPoint;
    var response = await dio.post(url, data: {
      "id": note.id,
    });
    debugPrint(response.data.toString());
  }

  Future<void> updateNotes(Note note) async {
    String endPoint = '/updateNotes';
    String url = baseUrl + endPoint;
    var response = await dio.post(url, data: {
      "id": note.id,
      "title": note.title,
      "content": note.content,
      "pinned": note.pinned,
      "colorIndex": note.colorIndex,
    });
    debugPrint(response.data.toString());
  }
}
