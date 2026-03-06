class QueueItem {
  String id;
  String type;
  Map<String, dynamic> payload;
  int retryCount;

  QueueItem({
    required this.id,
    required this.type,
    required this.payload,
    this.retryCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "payload": payload,
      "retryCount": retryCount,
    };
  }

  factory QueueItem.fromMap(Map map) {
    return QueueItem(
      id: map["id"],
      type: map["type"],
      payload: Map<String, dynamic>.from(map["payload"]),
      retryCount: map["retryCount"] ?? 0,
    );
  }
}
