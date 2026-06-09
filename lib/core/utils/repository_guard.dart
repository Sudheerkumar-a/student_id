import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/exceptions.dart';
import 'package:student_id/core/errors/failures.dart';

Future<Either<Failure, T>> guardRepository<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on ServerException catch (error) {
    return Left(ServerFailure(message: error.message));
  } catch (error) {
    return Left(ServerFailure(message: error.toString()));
  }
}
