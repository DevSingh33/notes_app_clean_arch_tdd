// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notes_cubit.dart';

abstract class NotesCubitState extends Equatable {
  const NotesCubitState();

  @override
  List<Object> get props => [];
}

class NotesCubitInitial extends NotesCubitState {}

class NotesCubitLoading extends NotesCubitState {}

class NotesCubitLoaded extends NotesCubitState {
  final List<NoteEntity>? notesList;

  const NotesCubitLoaded({required this.notesList});
}

class NotesCubitError extends NotesCubitState {
  final String errorMsg;
  const NotesCubitError({
    required this.errorMsg,
  });
}
