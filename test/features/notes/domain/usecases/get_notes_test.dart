import 'package:assign_notes_app_clean_architecture_tdd/core/error/failures.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/get_notes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository repository;
  late GetNotes useCase;

  setUp(() {
    repository = MockNotesRepository();
    useCase = GetNotes(notesRepository: repository);
  });

  final tNotes = [
    const NoteEntity(title: 'title', description: "description", dateTime: "dateTime"),
    const NoteEntity(title: 'title', description: "description", dateTime: "dateTime"),
    const NoteEntity(title: 'title', description: "description", dateTime: "dateTime"),
     ];
  test('should return all notes when getNotes() is success', () async {
    //arrange
    when(() => repository.getNotes()).thenAnswer((_) async =>  Right(tNotes));
    //act
    final result = await useCase(NoParams());
    //assert
    verify(() => repository.getNotes());
    verifyNoMoreInteractions(repository);
    expect(result, equals( Right(tNotes)));
  });

  test('should return [Failure] when getting notes list result in error', () async {
    //arrange
    when(() => repository.getNotes()).thenAnswer((_) async => const Left(Failure(msg: kerrorGetNotes)));
    //act
    final result = await useCase(NoParams());
    //assert
    verify(() => repository.getNotes());
    verifyNoMoreInteractions(repository);
    expect(result, equals(const Left(Failure(msg: kerrorGetNotes))));
  });
}
