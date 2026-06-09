import 'package:student_id/core/errors/failures.dart';

String failureMessage(Failure failure) {
  return switch (failure) {
    ServerFailure(:final message) => message,
    CacheFailure(:final message) => message,
    _ => 'An unknown error has occurred',
  };
}
