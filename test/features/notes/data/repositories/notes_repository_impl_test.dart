import 'package:assign_notes_app_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/network/connection_checker.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/local_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/remote_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';


class MockNotesRemoteDataSource extends Mock implements NotesRemoteDataSource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class MockNotesLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late MockNotesRemoteDataSource remoteDataSource;
  late NotesRepository notesRepository;
  late MockNotesLocalDataSource localDataSource;
  late MockConnectionChecker connectionChecker;

  setUp(() {
    remoteDataSource = MockNotesRemoteDataSource();
    localDataSource = MockNotesLocalDataSource();
    connectionChecker = MockConnectionChecker();
    notesRepository = NotesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      connectionChecker: connectionChecker,
      localDataSource: localDataSource,
    );
  });

  const tNoteModel = NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle");
  const tNoteEntity = NoteEntity(title: "noteTitle", description: "noteDescription", dateTime: "noteDateTime");
  final tNotes = [
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
    const NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle"),
  ];

  //! notes repo test - getAllNotes()
  group('notes repo - getAllNotes()', () {
    test('should call getAllNotes() when call notes repository', () async {
      //arrange
      when(() => remoteDataSource.getAllNotes()).thenAnswer((_) async => tNotes);
      //act
      await notesRepository.getNotes();
      //assert
      verify(() => remoteDataSource.getAllNotes());
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('''should return right side [NotesList] when notes list 
      return successfully from local data source''', () async {
      //arrange
      when(() => remoteDataSource.getAllNotes()).thenAnswer((_) async => tNotes);
      //act
      final result = await notesRepository.getNotes();
      //assert
      expect(result, equals(Right(tNotes)));
    });
  });

  //! notes repo test - addNote()
  group('notes repo test - addNote()', () {
    test('should call addNote() when call notes repository', () async {
      //arrange
      when(() => remoteDataSource.addNote(tNoteModel)).thenAnswer((_) async => tNoteModel);
      //act
      await notesRepository.addNote(note: tNoteEntity);
      //assert
      verify(() => remoteDataSource.addNote(tNoteModel));
      verifyNoMoreInteractions(remoteDataSource);
    });
    test('should return right side [NoteModel] ', () async {
      //arrange
      when(() => remoteDataSource.addNote(tNoteModel)).thenAnswer((_) async => tNoteModel);
      //act
      final result = await notesRepository.addNote(note: tNoteEntity);
      //assert
      expect(result, equals(const Right(tNoteModel)));
    });

    test('should return left side [Failure] when adding notes fail', () async {
      //arrange
      when(() => remoteDataSource.addNote(tNoteModel)).thenThrow(CacheException());
      //act
      final result = await notesRepository.addNote(note: tNoteEntity);
      //assert
      expect(result, equals(const Left(CacheFailure(kerrorAddNote))));
    });
  });
  //! notes repo test - deleteNote()
  group('notes repo test - deleteNote()', () {
    test('should return right side [true] when note is deleted successfully', () async {
      //arrange
      when(() => remoteDataSource.deleteNote(2)).thenAnswer((_) async => true);
      //act
      final result = await notesRepository.deleteNote(noteId: 2);
      //assert
      expect(result, equals(const Right(true)));
    });

    test('should return left side [Failure] when deleting notes fail', () async {
      //arrange
      when(() => remoteDataSource.deleteNote(3)).thenThrow(CacheException());
      //act
      final result = await notesRepository.deleteNote(noteId: 3);
      //assert
      expect(result, equals(const Left(CacheFailure(kerrorDeleteNote))));
    });
  });
  //! notes repo test - editNote()
  group('notes repo test - editNote()', () {
    //TODO: write correct test
    test('should return right side [NoteModel] when note is updated successfully', () async {
      //arrange
      when(() => remoteDataSource.editNote(tNoteModel, any())).thenAnswer((_) async => tNoteModel);
      //act
      final result = await notesRepository.editNote(note: tNoteEntity);
      //assert
      expect(result, equals(const Right(tNoteEntity)));
    });
    //TODO: write correct test
    test('should return left side [Failure] when updating notes fail', () async {
      //arrange
      when(() => remoteDataSource.editNote(tNoteModel, any())).thenThrow(CacheException());
      //act
      final result = await notesRepository.editNote(note: tNoteEntity);
      //assert
      expect(result, equals(const Left(CacheFailure(kerrorUpdateNote))));
    });
  });
}
