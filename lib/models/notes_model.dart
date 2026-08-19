class NoteModel {
  final String id = DateTime.now().toString();
  final String title;
  final String content;

  NoteModel({required this.title, required this.content});
}