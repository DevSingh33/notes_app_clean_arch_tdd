import 'package:assign_notes_app_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/network/connection_checker.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/local_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/remote_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:fpdart/fpdart.dart';

///Implement of [NotesRepository] class
class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;
  const NotesRepositoryImpl({required this.remoteDataSource, required this.connectionChecker, required this.localDataSource});

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotes() async {
    if (await connectionChecker.isConnected) {
      try {

        final result = await remoteDataSource.getAllNotes();
        await localDataSource.deleteAllNote();
        for (var note in result) {
         await localDataSource.addNote(note);
        }
        return Right(result);
      } on NetworkException {
        return const Left(NetworkFailure('$kerrorGetNotes\n->$kerrorCheckConnection'));
      }
    } else {

      try {
        final result = await localDataSource.getAllNotes();
        return Right(result!);
      } on CacheException {
        return const Left(CacheFailure('${kerrorGetNotes}from local storage'));
      }
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> getSingleNote({required int noteId}) async {
    if (await connectionChecker.isConnected) {
      try {
        final result = await remoteDataSource.getSingleNote(noteId);

        if (result == null) {
          return const Left(NetworkFailure(kerrorGetNotes));
        } else {
          return Right(result);
        }
      } on NetworkException {
        return const Left(NetworkFailure('$kerrorGetNotes\n->$kerrorCheckConnection'));
      }
    } else {
      try {

        final result = await localDataSource.getSingleNote(noteId);

        if (result == null) {
          return const Left(CacheFailure(kerrorGetNotes));
        } else {
          return Right(result);
        }
      } on CacheException {
        return const Left(CacheFailure(kerrorGetNotes));
      }
    }
  }

 

  @override
  Future<Either<Failure, NoteEntity>> addNote({required NoteEntity note}) async {
    try {
      final addNote = NoteModel(noteDescription: note.description, noteDateTime: note.dateTime, noteId: note.id, noteTitle: note.title);
      final noteModel = await remoteDataSource.addNote(addNote);
      // await localDataSource.addNote(addNote);
      return Right(noteModel);
    } on NetworkException {
      return const Left(NetworkFailure('$kerrorAddNote\n->$kerrorCheckConnection'));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> editNote({required NoteEntity note}) async {
    try {
      final result = await remoteDataSource.editNote(NoteModel.copy(note), note.id!); //TODO: check type conversion
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure('$kerrorUpdateNote\n->$kerrorCheckConnection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNote({required int noteId}) async {
    try {
      await remoteDataSource.deleteNote(noteId);
      // await localDataSource.deleteNote(noteId);
      return const Right(true);
    } on NetworkException {
      return const Left(NetworkFailure(kerrorDeleteNote));
    }
  }
}
