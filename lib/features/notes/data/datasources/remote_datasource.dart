import 'package:assign_notes_app_clean_architecture_tdd/core/api_routes/routes.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

abstract class NotesRemoteDataSource {
  ///[getAllNotes] will access the [RemoteDataSource] class and will get all the items[notes] through it.
  Future<List<NoteModel>> getAllNotes();

  ///[addNote] will access the [RemoteDataSource] class and will add items[note] to local db through it.
  Future<NoteModel> addNote(NoteModel note);

  ///[editNote] will access the [RemoteDataSource] class and will update the [note] item in the local db(with new values) through it.
  Future<NoteModel> editNote(NoteModel note, int id);

  ///[getAllNotes] will access the [RemoteDataSource] class and will delete the item[note] with (passed [id]) through it.
  Future<bool> deleteNote(int noteId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  static final Dio _dioClient = GetIt.I<Dio>();
  @override
  Future<NoteModel> addNote(NoteModel note) async {
    try {
      Map<String, dynamic> body = {"title": note.title, "description": note.description, "dateTime": note.dateTime};
      Response response = await _dioClient.post(ApiRoutes.addNote, data: body);
      note = NoteModel.fromJson(response.data);
      return note;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteNote(int noteId) async {
    try {
      await _dioClient.delete(ApiRoutes.deleteNote(noteId));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<NoteModel> editNote(NoteModel note, int id) async {
    try {
      Map<String, dynamic> body = {"title": note.title, "description": note.description, "dateTime": note.dateTime};
      await _dioClient.put(ApiRoutes.updateNote(id), data: body);
      return note;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    List<NoteModel> notes = [];
    try {
      Response response = await _dioClient.get(ApiRoutes.fetchAllNotes);
      List<dynamic> jsonNotes = response.data;
      notes = jsonNotes.map((e) => NoteModel.fromJson(e)).toList();
      return notes;
    } catch (e) {
      rethrow;
    }
  }
}
