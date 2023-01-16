import 'dart:developer';

import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//CLass for handling local database(SQFlite) and it's services like (CRUD operations)
class DbService {
  late final Database? _db;

  ///[createDB] to create the sql database in users device
  Future<Database> createDB() async {
    if (_db != null) {
      return _db!;
    }

    String path = join(await getDatabasesPath(), 'notes.db');
    _db = await openDatabase(path, version: 1, onCreate: (Database db, int v) {
      db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            dateTime TEXT
          );
        ''').catchError((val) => log(val));
    });
    return _db!;
  }

  ///[createItem] create a [NoteModel] note item in the database table
  Future<int> createItem(NoteModel note) async {
    Database db = await createDB();
    return db.insert('notes', note.toJson());
  }

  ///[updateItem] to update the already present [note] item in database table
  Future<int> updateItem(NoteModel note) async {
    Database db = await createDB();
    return db.update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }

  ///[allItems] fetch all the items from the database table
  Future allItems() async {
    Database db = await createDB();
    return db.query('notes');
  }

  ///[deleteItem] delete the item with passed [id]
  Future<int> deleteItem(int id) async {
    Database db = await createDB();
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
