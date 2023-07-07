import 'package:dartz/dartz.dart';
import 'package:student_id/domain/entities/zone.dart';
import 'package:student_id/domain/repositories/api_repository.dart';
import 'package:student_id/presentation/ui/screens/list_screen.dart';

import '../../core/errors/failures.dart';

class GetZones {
  final ApisRepository repository;

  GetZones({required this.repository});

  Future<Either<Failure, List<Zones>>> execute(ListType listType,
      {String lookupId = ''}) async {
    if (listType == ListType.zones) {
      return repository.getZones();
    } else if (listType == ListType.institutes) {
      return repository.getInstitutes(lookupId: lookupId);
    } else if (listType == ListType.colleges) {
      return repository.getColleges();
    } else if (listType == ListType.classes) {
      return repository.getClasses();
    } else {
      return repository.getClassesColleges();
    }
  }
}
