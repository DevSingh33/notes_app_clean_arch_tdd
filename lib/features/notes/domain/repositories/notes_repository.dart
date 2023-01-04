import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:fpdart/fpdart.dart';

abstract class NotesRepository {
  Either<Failure, List<Note>> getNotes();
}
