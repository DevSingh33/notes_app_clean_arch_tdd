part of 'note_cubit.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteCubitLoading extends NoteState {}


class NoteCubitLoaded extends NoteState {
  final NoteEntity note;

  const NoteCubitLoaded({required this.note});
}

class NoteCubitError extends NoteState {
  final String errorMsg;
  const NoteCubitError({
    required this.errorMsg,
  });
}