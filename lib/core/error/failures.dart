import 'package:equatable/equatable.dart';

//Parent class for all types of failure
class Failure extends Equatable {
  final String msg;

  const Failure({required this.msg});

  @override
  List<Object?> get props => [msg];
}

//CacheFilure class with error message property
class CacheFailure extends Failure {
  const CacheFailure(String msg) : super(msg: msg);
}

//custom error for all possible cases
const String kerrorGetNotes = 'Error in getting notes';
const String kerrorDeleteNote = 'Error in removing a note';
const String kerrorUpdateNote = 'Error in updating a note';
const String kerrorAddNote = 'Error adding a new note';
