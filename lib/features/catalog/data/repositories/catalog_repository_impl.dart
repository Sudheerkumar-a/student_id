import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/core/network/remote_data_store.dart';
import 'package:student_id/core/utils/repository_guard.dart';
import 'package:student_id/features/catalog/data/mock_catalog_data.dart';
import 'package:student_id/features/catalog/data/models/zone_model.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final RemoteDataStore _remote;

  CatalogRepositoryImpl(this._remote);

  static List<ZoneModel> _parseZoneList(dynamic data) =>
      (data as List).map((e) => ZoneModel.fromJson(e)).toList();

  Future<Either<Failure, List<Zones>>> _loadZones(
    Future<List<ZoneModel>> Function() fetch,
  ) {
    return guardRepository(() async {
      final models = await fetch();
      return models.map((e) => e.toEntity).toList();
    });
  }

  @override
  Future<Either<Failure, List<Zones>>> getZones(String lookupId) =>
      _loadZones(
        () => _remote.get(
          'master/zone?lookupId=$lookupId',
          parser: _parseZoneList,
        ),
      );

  @override
  Future<Either<Failure, List<Zones>>> getInstitutes({
    required String lookupId,
  }) =>
      _loadZones(
        () => _remote.get(
          'master/school?lookupId=$lookupId',
          parser: _parseZoneList,
        ),
      );

  @override
  Future<Either<Failure, List<Zones>>> getColleges() =>
      _loadZones(() async => mockColleges);

  @override
  Future<Either<Failure, List<Zones>>> getClasses() =>
      _loadZones(() async => mockClasses);

  @override
  Future<Either<Failure, List<Zones>>> getClassesColleges() =>
      _loadZones(() async => [...mockClasses, ...mockColleges]);
}
