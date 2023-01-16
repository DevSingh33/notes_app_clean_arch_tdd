import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:fpdart/fpdart.dart';

///[EditNote] usecase for updating a [note] in the db
class EditNote extends UseCase<NoteEntity, NoteParams> {
  final NotesRepository notesRepository;
  EditNote({required this.notesRepository});

  @override
  Future<Either<Failure, NoteEntity>> call(NoteParams params) {
    return notesRepository.editNote(note: params.note);
  }
}

