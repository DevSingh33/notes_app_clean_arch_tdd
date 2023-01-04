import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {      //!Type- is the return type, Params- is the parameters passed to this class and will be used in the call()
  Either<Failure, Type> call();
}

// This will be used by the code calling the use case whenever the use case
// doesn't accept any parameters.
class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}