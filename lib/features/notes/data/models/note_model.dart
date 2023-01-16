import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';

//Class will be used in local database access and mapping with [NoteEntity] object
class NoteModel extends NoteEntity {
  const NoteModel({
    required String noteDescription,
    required String noteDateTime,
    int? noteId,
    required String noteTitle,
  }) : super(id: noteId, title: noteTitle, dateTime: noteDateTime, description: noteDescription);

  ///copy constructore(useful for mapping of [NoteModel] object's value to [NoteEntity] object)
  NoteModel.copy(NoteEntity noteEntity)
      : this(noteId: noteEntity.id, noteTitle: noteEntity.title, noteDateTime: noteEntity.dateTime, noteDescription: noteEntity.description);

  ///getting [NoteModel] object from the passed [json] values
  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      NoteModel(noteTitle: json['title'], noteDateTime: json['dateTime'], noteDescription: json['description'], noteId: json['id']);

  ///converting the properties to [json] value type
  Map<String, dynamic> toJson() => {'title': title, 'description': description, 'id': id, 'dateTime': dateTime};
}
