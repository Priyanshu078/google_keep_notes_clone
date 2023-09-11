class Note {
  final String id;
  final String userid;
  final String content;
  final String title;
  final String dateAdded;

  Note(
      {required this.id,
      required this.userid,
      required this.content,
      required this.title,
      required this.dateAdded});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        userid: json['userid'],
        content: json['content'],
        title: json['title'],
        dateAdded: json['dateAdded']);
  }

  Note copyWith(String content, String title, String dateAdded) {
    return Note(
        id: id,
        userid: userid,
        content: content,
        title: title,
        dateAdded: dateAdded);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userid": userid,
      "content": content,
      "title": title,
      "dateadded": dateAdded.toString()
    };
  }
}
