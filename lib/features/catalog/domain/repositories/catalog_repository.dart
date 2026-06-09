import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';

abstract class CatalogRepository {
  Future<Either<Failure, List<Zones>>> getZones(String lookupId);
  Future<Either<Failure, List<Zones>>> getInstitutes({required String lookupId});
  Future<Either<Failure, List<Zones>>> getColleges();
  Future<Either<Failure, List<Zones>>> getClasses();
  Future<Either<Failure, List<Zones>>> getClassesColleges();
}
