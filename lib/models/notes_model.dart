import 'package:hive/hive.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;
  @HiveField(3)
  NoteType type = NoteType.ACTIVE;

  NoteModel({String? id, required this.title, required this.content}): id = id ?? DateTime.now().toString();
}

@HiveType(typeId: 1)
enum NoteType {
  @HiveField(0)
  ACTIVE,
  
  @HiveField(1)
  ARCHIVED,
  
  @HiveField(2)
  DELETED,
}