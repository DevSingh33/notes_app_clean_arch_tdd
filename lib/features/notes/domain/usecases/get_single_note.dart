import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';

import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:fpdart/fpdart.dart';

///[GetSingleNote] usecase for getting all the notes from the db
class GetSingleNote extends UseCase<NoteEntity, int> {
  final NotesRepository notesRepository;
  GetSingleNote({required this.notesRepository});

  @override
  Future<Either<Failure, NoteEntity>> call(int params) {
    return notesRepository.getSingleNote(noteId: params);
  }
}