// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assign_notes_app_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/services/local_db.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';

///Contract class for accessing local database
abstract class LocalDataSource {
  ///[getAllNotes] will access the [LocalDataSource] class and will get all the items[notes] through it.
  Future<List<NoteModel>?> getAllNotes();

  ///[getSingleNote] will access the [LocalDataSource] class and will get all the item[note] through it.
  Future<NoteModel?> getSingleNote(int noteId);

  ///[addNote] will access the [LocalDataSource] class and will add items[note] to local db through it.
  Future<NoteModel> addNote(NoteModel note);

  ///[editNote] will access the [LocalDataSource] class and will update the [note] item in the local db(with new values) through it.
  Future<NoteModel> editNote(NoteModel note);

  ///[deleteNote] will access the [LocalDataSource] class and will delete the item[note] with (passed [id]) through it.
  Future<bool> deleteNote(int noteId);

  ///[deleteAllNote] will access the [LocalDataSource] class and will delete  all the item[note].
  Future<bool> deleteAllNote();
}

///Implementing the [LocalDataSource]
class LocalDataSourceImpl implements LocalDataSource {
  final DbService dbService;
  LocalDataSourceImpl({required this.dbService});

  @override
  Future<List<NoteModel>?> getAllNotes() async {
    try {
      final result = await dbService.allItems();
      if (result != null) {
        return List<NoteModel>.from(result.map((item) => NoteModel.fromJson(item)));
      } else {
        return [];
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<NoteModel?> getSingleNote(int noteId) async {
    try {
      final result = await dbService.singleItem(noteId);
      if (result != null) {
        return NoteModel.fromJson(result);
      } else {
        return null;
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<NoteModel> addNote(NoteModel note) async {
    try {
      await dbService.createItem(note);
      return note;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> deleteNote(int noteId) async {
    try {
      await dbService.deleteItem(noteId);

      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<NoteModel> editNote(NoteModel note) async {
    try {
      await dbService.updateItem(note);
      return note;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> deleteAllNote() async {
    try {
      await dbService.deleteAllItems();
      return true;
    } catch (e) {
      throw CacheException();
    }
  }
}
