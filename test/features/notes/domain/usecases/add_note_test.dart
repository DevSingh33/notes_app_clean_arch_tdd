
import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/add_note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository repository;
  late AddNote useCase;

  setUp(() {
    repository = MockNotesRepository();
    useCase = AddNote(notesRepository: repository);
  });

  const tNoteEntity = NoteEntity(title: "noteTitle", description: "noteDescription", dateTime: "noteDateTime");
 
  test('should return [Note Entity] when data return successully', () async {
    //arrange
    when(() => repository.addNote(note:tNoteEntity))
        .thenAnswer((_) async =>  const Right(tNoteEntity));
    //act
    final result = await useCase(const NoteParams(note: tNoteEntity));
    //assert
    verify(() => repository.addNote(note: tNoteEntity));
    verifyNoMoreInteractions(repository);
    expect(result, equals( const Right(tNoteEntity)));
  });

  test('should return [Failure] when data return result in error', () async {
    //arrange
    when(() => repository.addNote(note: tNoteEntity))
        .thenAnswer((_) async =>  const Left(Failure(msg: kerrorAddNote)));
    //act
    final result = await useCase(const NoteParams(note: tNoteEntity));
    //assert
    verify(() => repository.addNote(note: tNoteEntity));
    verifyNoMoreInteractions(repository);
    expect(result, equals(const Left(Failure(msg: kerrorAddNote))));
  });
}
