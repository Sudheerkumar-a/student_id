import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';

class ListScreenArgs {
  final InstituteType instituteType;
  final ListType listType;
  final String zoneId;
  final String instituteId;
  final String instituteName;
  final String classId;

  const ListScreenArgs(
    this.instituteType,
    this.listType, {
    this.zoneId = '',
    this.instituteId = '',
    this.classId = '',
    this.instituteName = '',
  });
}
