
import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/delete_note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository repository;
  late DeleteNote useCase;

  setUp(() {
    repository = MockNotesRepository();
    useCase = DeleteNote(notesRepository: repository);
  });

 
  test('should return true when deleting note successully', () async {
    //arrange
    when(() => repository.deleteNote(noteId: 1))
        .thenAnswer((_) async =>  const Right(true));
    //act
    final result = await useCase(1);
    //assert
    verify(() => repository.deleteNote(noteId: 1));
    verifyNoMoreInteractions(repository);
    expect(result, equals( const Right(true)));
  });

  test('should return [Failure] when data return result in error', () async {
    //arrange
    when(() => repository.deleteNote(noteId: 2))
        .thenAnswer((_) async =>  const Left(Failure(msg: kerrorDeleteNote)));
    //act
    final result = await useCase(2);
    //assert
    verify(() => repository.deleteNote(noteId: 2));
    verifyNoMoreInteractions(repository);
    expect(result, equals(const Left(Failure(msg: kerrorDeleteNote))));
  });
}
