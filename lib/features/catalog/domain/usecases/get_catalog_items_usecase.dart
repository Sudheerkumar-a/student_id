import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/domain/repositories/catalog_repository.dart';

class GetCatalogItemsUseCase {
  final CatalogRepository repository;

  GetCatalogItemsUseCase(this.repository);

  Future<Either<Failure, List<Zones>>> call(
    ListType listType, {
    String lookupId = '',
  }) {
    return switch (listType) {
      ListType.zones => repository.getZones(lookupId),
      ListType.institutes => repository.getInstitutes(lookupId: lookupId),
      ListType.colleges => repository.getColleges(),
      ListType.classes => repository.getClasses(),
      ListType.classesColleges => repository.getClassesColleges(),
    };
  }
}
