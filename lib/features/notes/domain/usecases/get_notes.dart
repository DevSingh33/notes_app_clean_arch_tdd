import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';

import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:fpdart/fpdart.dart';

///[GetNotes] usecase for getting all the notes from the db
class GetNotes extends UseCase<List<NoteEntity>, NoParams> {
  final NotesRepository notesRepository;
  GetNotes({required this.notesRepository});

  @override
  Future<Either<Failure, List<NoteEntity>>> call(NoParams params) {
    return notesRepository.getNotes();
  }
}
