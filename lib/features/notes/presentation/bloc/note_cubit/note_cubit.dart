import 'package:assign_notes_app_clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/delete_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/edit_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/get_single_note.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final GetSingleNote getSingleNoteUseCase;
  final DeleteNote deleteNoteUseCase;
  final EditNote editNoteUseCase;
  NoteCubit({required this.getSingleNoteUseCase, required this.deleteNoteUseCase, required this.editNoteUseCase}) : super(NoteInitial());

  ///[getSingleNote] will call the [getSingleNoteUseCase] and according to the result it will emit the [note]or emit the error
  Future<void> getSingleNote({required int id}) async {
    emit(NoteCubitLoading());
    final result = await getSingleNoteUseCase.call(id);
    result.fold(
      (error) => emit(NoteCubitError(errorMsg: error.msg)), //if result is failure(left side)
      (note) async {
        emit(NoteCubitLoaded(note: note));
        // await getAllNotes();
      }, //if result is object or anything defined(right side)
    );
  }


    ///[deleteANote] will call the [deleteNoteUseCase] and according to the result it will emit the [notes] list(without the paased note's id) or emit the error
  Future<void> deleteANote(int noteId) async {
    final result = await deleteNoteUseCase.call(noteId);
    result.fold((error) => emit(NoteCubitError(errorMsg: error.msg)), (note) async {
      // await getAllNotes();
    });
  }

  ///[editANote] will call the [editNoteUseCase] and according to the result it will emit the [notes] list(with updated note's value) or emit the error
  Future<void> editANote(NoteEntity note) async {
    final result = await editNoteUseCase.call(NoteParams(note: note));
    result.fold((error) => emit(NoteCubitError(errorMsg: error.msg)), (note) async {
      await getSingleNote(id: note.id!);
    });
  }
}
