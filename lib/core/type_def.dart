import 'package:fpdart/fpdart.dart';
import 'package:rope/core/failure.dart';

typedef FutureEither<T>=Future<Either<Failure,T>>;
typedef FutureVoid<T>=FutureEither<void>;