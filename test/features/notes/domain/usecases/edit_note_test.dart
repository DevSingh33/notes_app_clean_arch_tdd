
import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/edit_note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository repository;
  late EditNote useCase;

  setUp(() {
    repository = MockNotesRepository();
    useCase = EditNote(notesRepository: repository);
  });

  const tNoteEntity = NoteEntity(title: "noteTitle", description: "noteDescription", dateTime: "noteDateTime");
 
  test('should return true when editing note successully', () async {
    //arrange
    when(() => repository.editNote(note: tNoteEntity))
        .thenAnswer((_) async =>  const Right(tNoteEntity));
    //act
    final result = await useCase(const NoteParams(note: tNoteEntity));
    //assert
    verify(() => repository.editNote(note: tNoteEntity));
    verifyNoMoreInteractions(repository);
    expect(result, equals( const Right(tNoteEntity)));
  });

  test('should return [Failure] when editing note result in error', () async {
    //arrange
    when(() => repository.editNote(note: tNoteEntity))
        .thenAnswer((_) async =>  const Left(Failure(msg: kerrorUpdateNote)));
    //act
    final result = await useCase(const NoteParams(note: tNoteEntity));
    //assert
    verify(() => repository.editNote(note: tNoteEntity));
    verifyNoMoreInteractions(repository);
    expect(result, equals(const Left(Failure(msg: kerrorUpdateNote))));
  });
}
