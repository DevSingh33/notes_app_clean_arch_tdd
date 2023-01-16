// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:fpdart/fpdart.dart';

import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';

///[AddNote] use for adding note to db
class AddNote extends UseCase<NoteEntity, NoteParams> {
  final NotesRepository notesRepository;
  AddNote({
    required this.notesRepository,
  });

  @override
  Future<Either<Failure, NoteEntity>> call(NoteParams params) {
    return notesRepository.addNote(note: params.note);
  }
}
