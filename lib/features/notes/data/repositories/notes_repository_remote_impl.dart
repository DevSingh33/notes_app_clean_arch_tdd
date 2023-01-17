import 'package:assign_notes_app_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/remote_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:fpdart/fpdart.dart';

///Implement of [NotesRepository] class
class NotesRepositoryRemoteImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;

  const NotesRepositoryRemoteImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotes() async {
    try {
      final result = await remoteDataSource.getAllNotes();
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure(kerrorGetNotes));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> addNote({required NoteEntity note}) async {
    try {
      final addNote = NoteModel(noteDescription: note.description, noteDateTime: note.dateTime, noteId: note.id, noteTitle: note.title);
      final noteModel = await remoteDataSource.addNote(addNote);
      return Right(noteModel);
    } on CacheException {
      return const Left(CacheFailure(kerrorAddNote));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> editNote({required NoteEntity note}) async {
    try {
      final result = await remoteDataSource.editNote(NoteModel.copy(note), note.id!); //TODO: check type conversion
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure(kerrorUpdateNote));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNote({required int noteId}) async {
    try {
      await remoteDataSource.deleteNote(noteId);
      return const Right(true);
    } on CacheException {
      return const Left(CacheFailure(kerrorDeleteNote));
    }
  }
}
