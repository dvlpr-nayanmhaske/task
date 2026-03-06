class Note {
  String id;
  String text;
  bool liked;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.text,
    required this.liked,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text": text,
      "liked": liked,
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map map) {
    return Note(
      id: map["id"],
      text: map["text"],
      liked: map["liked"],
      updatedAt: DateTime.parse(map["updatedAt"]),
    );
  }
}
