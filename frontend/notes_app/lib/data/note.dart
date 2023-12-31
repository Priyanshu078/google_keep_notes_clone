class Note {
  final String id;
  final String userid;
  final String content;
  final String title;
  final String dateAdded;
  final bool pinned;
  final int colorIndex;
  final bool trashed;
  final bool archived;
  final bool selected;

  Note({
    required this.id,
    required this.userid,
    required this.content,
    required this.title,
    required this.dateAdded,
    required this.pinned,
    required this.colorIndex,
    required this.trashed,
    required this.archived,
    required this.selected,
  });

  Note.temp({
    this.id = "",
    this.userid = "",
    this.content = "",
    this.title = "",
    this.dateAdded = "",
    this.pinned = false,
    this.colorIndex = 0,
    this.trashed = false,
    this.archived = false,
    this.selected = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      userid: json['userid'],
      content: json['content'],
      title: json['title'],
      dateAdded: json['dateAdded'],
      pinned: json['pinned'],
      colorIndex: json['colorIndex'],
      trashed: json['trashed'],
      archived: json['archived'],
      selected: json['selected'],
    );
  }

  Note copyWith({
    String? id,
    String? userid,
    String? content,
    String? title,
    String? dateAdded,
    bool? pinned,
    int? colorIndex,
    bool? trashed,
    bool? archived,
    bool? selected,
  }) {
    return Note(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      content: content ?? this.content,
      title: title ?? this.title,
      dateAdded: dateAdded ?? this.dateAdded,
      pinned: pinned ?? this.pinned,
      colorIndex: colorIndex ?? this.colorIndex,
      trashed: trashed ?? this.trashed,
      archived: archived ?? this.archived,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userid": userid,
      "content": content,
      "title": title,
      "dateAdded": dateAdded,
      "pinned": pinned,
      "colorIndex": colorIndex,
      "trashed": trashed,
      "archived": archived,
      "selected": selected,
    };
  }
}
