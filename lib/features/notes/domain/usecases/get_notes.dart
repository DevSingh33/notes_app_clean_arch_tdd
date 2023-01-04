// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';

import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetNotes extends UseCase {
  final NotesRepository notesRepository;
   GetNotes({
    required this.notesRepository,
  });

  @override
  Either<Failure, List<Note>> call() {
    return notesRepository.getNotes();
  }
}
