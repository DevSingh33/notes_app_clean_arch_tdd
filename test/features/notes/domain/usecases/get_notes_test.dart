import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/get_notes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late GetNotes usecase;
  late MockNotesRepository mockNotesRepository;

  setUp(() {
    mockNotesRepository = MockNotesRepository();
    usecase = GetNotes(notesRepository: mockNotesRepository);
  });

  const tNotesList = [
    Note(title: 'test note1', description: 'complete before 6 jan'),
    Note(title: 'test note2', description: 'buy vegetables'),
    Note(title: 'test note3', description: 'submit electricity bill'),
  ];

  test('should get all the notes', () {
    //arrange
    when(() => mockNotesRepository.getNotes()).thenReturn(const Right(tNotesList));
    //act
    final result =  usecase.call();
    //assert
    expect(result, const Right(tNotesList));
    verify(()=>mockNotesRepository.getNotes());
  });
}
