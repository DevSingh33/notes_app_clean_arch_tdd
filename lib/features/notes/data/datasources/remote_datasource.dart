import 'package:assign_notes_app_clean_architecture_tdd/core/api_routes/routes.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:dio/dio.dart';

abstract class NotesRemoteDataSource {
  ///[getAllNotes] will access the [RemoteDataSource] class and will get all the items[notes] through it.
  Future<List<NoteModel>> getAllNotes();

  ///[getSingleNote] will access the [RemoteDataSource] class and will get a item[note] with (passed [id]).
  Future<NoteModel?> getSingleNote(int noteId);

  ///[addNote] will access the [RemoteDataSource] class and will add items[note] through the api.
  Future<NoteModel> addNote(NoteModel note);

  ///[editNote] will access the [RemoteDataSource] class and will update the [note] item through the api.
  Future<NoteModel> editNote(NoteModel note, int id);

  ///[deleteNote] will access the [RemoteDataSource] class and will delete the item[note] with (passed [id]) through the api.
  Future<bool> deleteNote(int noteId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final Dio dioClient;
  NotesRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<NoteModel> addNote(NoteModel note) async {
    try {
      Map<String, dynamic> body = {"title": note.title, "description": note.description, "dateTime": note.dateTime};
      Response response = await dioClient.post(ApiRoutes.addNote, data: body);
      note = NoteModel.fromJson(response.data);
      return note;
    } catch (e) {
      throw NetworkException();
    }
  }

  @override
  Future<bool> deleteNote(int noteId) async {
    try {
      await dioClient.delete(ApiRoutes.deleteNote(noteId));
      return true;
    } catch (e) {
      throw NetworkException();
    }
  }

  @override
  Future<NoteModel> editNote(NoteModel note, int id) async {
    try {
      Map<String, dynamic> body = {"title": note.title, "description": note.description, "dateTime": note.dateTime};
      await dioClient.put(ApiRoutes.updateNote(id), data: body);
      return note;
    } catch (e) {
      throw NetworkException();
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    List<NoteModel> notes = [];
    try {
      Response response = await dioClient.get(ApiRoutes.fetchAllNotes);
      List<dynamic> jsonNotes = response.data;
      notes = jsonNotes.map((e) => NoteModel.fromJson(e)).toList();
      return notes;
    } catch (e) {
      throw NetworkException();
    }
  }

  @override
  Future<NoteModel?> getSingleNote(int noteId) async {
    NoteModel? note;
    try {
      Response response = await dioClient.get(ApiRoutes.fetchSingleNote(noteId));
      note = NoteModel.fromJson(response.data);
      return note;
    } catch (e) {
      NetworkException();
    }
    return note;
  }
}
