// for creating our own types
import 'package:fpdart/fpdart.dart';
import 'package:todo/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;