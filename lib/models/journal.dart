import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Journal({
    required this.id,
    required this.content,  
    required this.createdAt,
    required this.updatedAt,
  });

  Journal.empty()
      : id = const Uuid().v1(),
        content = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Journal.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        content = map['content'],
        createdAt = DateTime.parse(map['createdAt'].replaceAll("T", " ")),
        updatedAt = DateTime.parse(map['updatedAt'].replaceAll("T", " "));

  @override
  String toString() {
    return "$content \ncreatedAt: $createdAt\nupdatedAt:$updatedAt";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toString().replaceAll(" ", "T"),
      'updatedAt': updatedAt.toString().replaceAll(" ", "T")
    };
  }
}
