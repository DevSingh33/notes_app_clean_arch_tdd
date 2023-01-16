import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

///Contract for all UseCases(like add note use case)
abstract class UseCase<Type, Params> {
  //![Type]- is the return type, [Params]- is the parameters passed to this class and will be used in the call()
  Future<Either<Failure, Type>> call(Params params);
}

// This will be used by the code calling the use case whenever the use case
// doesn't accept any parameters.
class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NoteParams {
  final NoteEntity note;
  const NoteParams({required this.note});
}
