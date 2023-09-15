class Note {
  final String id;
  final String userid;
  final String content;
  final String title;
  final String dateAdded;
  final bool pinned;

  Note({
    required this.id,
    required this.userid,
    required this.content,
    required this.title,
    required this.dateAdded,
    required this.pinned,
  });

  Note.temp({
    this.id = "",
    this.userid = "",
    this.content = "",
    this.title = "",
    this.dateAdded = "",
    this.pinned = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        userid: json['userid'],
        content: json['content'],
        title: json['title'],
        dateAdded: json['dateAdded'],
        pinned: json['pinned']);
  }

  Note copyWith(
      {String? id,
      String? userid,
      String? content,
      String? title,
      String? dateAdded,
      bool? pinned}) {
    return Note(
        id: id ?? this.id,
        userid: userid ?? this.userid,
        content: content ?? this.content,
        title: title ?? this.title,
        dateAdded: dateAdded ?? this.dateAdded,
        pinned: pinned ?? this.pinned);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userid": userid,
      "content": content,
      "title": title,
      "dateadded": dateAdded.toString(),
      "pinned": pinned,
    };
  }
}
