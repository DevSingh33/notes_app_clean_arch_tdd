import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:fpdart/fpdart.dart';
///[DeleteNote] usecase for deleting a [note] from the db
class DeleteNote extends UseCase<bool, int> {
  final NotesRepository notesRepository;
  DeleteNote({required this.notesRepository});

  @override
  Future<Either<Failure, bool>> call(int params) {
    return notesRepository.deleteNote(noteId: params);
  }
}


