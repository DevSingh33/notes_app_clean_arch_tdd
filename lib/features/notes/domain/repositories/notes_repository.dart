import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:fpdart/fpdart.dart';

///Contract class for notes repository
abstract class NotesRepository {
  ///[getNotes] will get the result in either(List of NoteEntity) or (Failure) if some error occured
  Future<Either<Failure, List<NoteEntity>>> getNotes();
  ///[addNote] will add the [note] in db and result in either(NoteEntity) or (Failure) if some error occured
  Future<Either<Failure, NoteEntity>> addNote({required NoteEntity note});
  ///[deleteNote] will delete the [note] in db and result in either (True) or (Failure) if some error occured
  Future<Either<Failure, bool>> deleteNote({required int noteId});
  ///[editNote] will update the [note] in db and result in either(NoteEntity) or (Failure) if some error occured
  Future<Either<Failure, NoteEntity>> editNote({required NoteEntity note});
}
