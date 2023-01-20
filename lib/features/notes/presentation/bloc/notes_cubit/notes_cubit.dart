// ignore_for_file: depend_on_referenced_packages

import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/add_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/get_notes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesCubitState> {
  final GetNotes getNotesUseCase;
  final AddNote addNoteUseCase;

  NotesCubit({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
  }) : super(NotesCubitInitial());

  ///[getAllNotes] will call the [getNotesUseCase] and according to the result it will emit the [notes] list or emit the error
  Future<void> getAllNotes() async {
    emit(NotesCubitLoading());
    final result = await getNotesUseCase.call(NoParams());
    result.fold(
      (error) => emit(NotesCubitError(errorMsg: error.msg)), //if result is failure(left side)
      (notes) {
        emit(NotesCubitLoaded(notesList: notes));
      }, //if result is object or anything defined(right side)
    );
  }

  ///[saveNote] will call the [addNoteUseCase] and according to the result it will emit the [notes] list(with new note included) or emit the error
  Future<void> saveNote({String? noteTitle, required String noteDescription}) async {
    final result = await addNoteUseCase.call(
      NoteParams(note: NoteEntity(title: noteTitle ?? 'no title', description: noteDescription, dateTime: DateTime.now().toString())),
    );
    result.fold((error) => emit(NotesCubitError(errorMsg: error.msg)), (note) async => await getAllNotes());
  }
}
