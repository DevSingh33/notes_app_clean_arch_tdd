
import 'package:assign_notes_app_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/services/local_db.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/local_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDatabaseService extends Mock implements DbService {}

void main() {http://localhost:9000/api/notes/
  late MockLocalDatabaseService databaseService;
  late LocalDataSource localDataSource;

  setUp(() {
    databaseService = MockLocalDatabaseService();
    localDataSource = LocalDataSourceImpl(dbService: databaseService);
  });

  const tNoteModel = NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle");
  final tNotes = [
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
  ];
  final tNotesJson = [
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle").toJson(),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle").toJson(),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle").toJson(),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle").toJson(),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle").toJson(),
  ];

  final tNoteJson = const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle").toJson();
  //! local db test for allNotes()
  group('local db - get all notes ', () {
    test('should call get notes from database when invoked', () async {
      //arrange
      when(() => databaseService.allItems()).thenAnswer((invocation) async => tNotesJson);
      //act
      await localDataSource.getAllNotes();
      //assert
      verify(() => databaseService.allItems());
      verifyNoMoreInteractions(databaseService);
    });
    test('should  get notes from database when getAllNotes() called', () async {
      //arrange
      when(() => databaseService.allItems()).thenAnswer((invocation) async => tNotesJson);
      //act
      final result = await localDataSource.getAllNotes();
      //assert
      expect(result, tNotes);
    });

    test('notes list should return empty if database is return null for any reason', () async {
      //arrange
      when(() => databaseService.allItems()).thenAnswer((_) async => null);
      //act
      final result = await localDataSource.getAllNotes();
      //assert
      expect(result, equals([]));
    });
  });
  //! local db test for getSingleNote()
  group('local db - get single note ', () {
    test('should call get single note from database when invoked', () async {
      //arrange
      when(() => databaseService.singleItem(1)).thenAnswer((invocation) async => tNoteJson);
      //act
      await localDataSource.getSingleNote(1);
      //assert
      verify(() => databaseService.singleItem(1));
      verifyNoMoreInteractions(databaseService);
    });

    test('note should return null if database is return null for any reason', () async {
      //arrange
      when(() => databaseService.singleItem(1)).thenAnswer((_) async => null);
      //act
      final result = await localDataSource.getSingleNote(1);
      //assert
      expect(result, equals(null));
    });
    test('note should return a single note when getSingleNote(id) called ', () async {
      //arrange
      when(() => databaseService.singleItem(1)).thenAnswer((_) async => tNoteJson);
      //act
      final result = await localDataSource.getSingleNote(1);
      //assert
      expect(result, tNoteModel);
    });
  });

  //! local db test for addNote()
  group('local db - add note', () {
    test('should call [addNote()] when method invoked', () async {
      //arrange
      when(() => databaseService.createItem(tNoteModel)).thenAnswer((invocation) async => 0);
      //act
      await localDataSource.addNote(tNoteModel);
      verify(() => databaseService.createItem(tNoteModel));
      verifyNoMoreInteractions(databaseService);
    });

    test('should return [NoteModel] when stored successfully in database', () async {
      //arrange
      when(() => databaseService.createItem(tNoteModel)).thenAnswer((_) async => 1);
      //act
      final result = await localDataSource.addNote(tNoteModel);
      //assert
      expect(result, equals(tNoteModel));
    });

    test('should return [CacheException] when error is thrown', () async {
      //arrange
      when(() => databaseService.createItem(tNoteModel)).thenThrow(Exception());
      //act
      final result = localDataSource.addNote(tNoteModel);
      //assert
      expect(() => result, throwsA(const TypeMatcher<CacheException>()));
    });
  });

  //! local db test for deleteNote()
  group('local db - delete note', () {
    test('should return true if a note is deleted from db successfully', () async {
      //arrange
      when(() => databaseService.deleteItem(2)).thenAnswer((invocation) async => 1);
      //act
      final result = await localDataSource.deleteNote(2);
      //assert
      expect(result, equals(true));
    });
  });

  //! local db test for updateNote()
  test('should return [NoteModel] when editing of note from database is success', () async {
    //arrange
    when(() => databaseService.updateItem(tNoteModel)).thenAnswer((_) async => 2);
    //act
    final result = await localDataSource.editNote(tNoteModel);
    //assert
    expect(result, equals(tNoteModel));
  });
}
