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

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        userid: json['userid'],
        content: json['content'],
        title: json['title'],
        dateAdded: json['dateAdded'],
        pinned: json['pinned']);
  }

  Note copyWith(String content, String title, String dateAdded, bool pinned) {
    return Note(
        id: id,
        userid: userid,
        content: content,
        title: title,
        dateAdded: dateAdded,
        pinned: pinned);
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
