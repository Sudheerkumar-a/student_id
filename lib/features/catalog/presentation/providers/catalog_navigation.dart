import 'package:flutter/material.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/shared/presentation/widgets/staff_appbar_widget.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/shared/navigation/navigation_target.dart';

class CatalogNavigation {
  static bool isStaffLoggedIn(PrefUtils prefs) =>
      (prefs.getStringValue(SharedPreferencesString.userName) ?? '').isNotEmpty;

  static String titleFor(ListScreenArgs args) {
    switch (args.listType) {
      case ListType.zones:
        return 'Zones';
      case ListType.institutes:
        return 'Institutes';
      case ListType.colleges:
        return 'Colleges';
      case ListType.classes:
      case ListType.classesColleges:
        return 'Classes';
    }
  }

  static ListType nextListType(ListScreenArgs args, PrefUtils prefs) {
    if (args.listType == ListType.zones) {
      return ListType.institutes;
    }
    if (prefs.getBoolValue(SharedPreferencesString.isSchool)) {
      return ListType.classes;
    }
    return ListType.colleges;
  }

  static String _resolveState({
    required ListType listType,
    required String? dataState,
    required String argsState,
  }) {
    final data = (dataState ?? '').trim();
    final args = argsState.trim();

    if (listType == ListType.zones) {
      return data.isNotEmpty ? data : args;
    }
    return args.isNotEmpty ? args : data;
  }

  static ListScreenArgs nextArgs(
    ListScreenArgs args,
    Zones data,
    PrefUtils prefs,
  ) {
    final state = _resolveState(
      listType: args.listType,
      dataState: data.state,
      argsState: args.state,
    );

    var arguments = ListScreenArgs(
      args.instituteType,
      nextListType(args, prefs),
      zoneId: '${data.id}',
      state: state,
    );
    if (args.listType == ListType.institutes) {
      arguments = ListScreenArgs(
        args.instituteType,
        nextListType(args, prefs),
        zoneId: args.zoneId,
        instituteId: '${data.id}',
        instituteName: '${data.name}',
        state: state,
      );
    } else if (args.listType == ListType.classes ||
        args.listType == ListType.colleges) {
      var instituteId = args.instituteId;
      if (isStaffLoggedIn(prefs)) {
        instituteId =
            prefs.getStringValue(SharedPreferencesString.instituteID) ?? '';
      }
      arguments = ListScreenArgs(
        args.instituteType,
        nextListType(args, prefs),
        zoneId: args.zoneId,
        instituteId: instituteId,
        instituteName: args.instituteName,
        classId: '${data.id}',
        state: state,
      );
    }
    return arguments;
  }

  static PreferredSizeWidget appBarFor(ListScreenArgs args, PrefUtils prefs) {
    final title = titleFor(args);
    if (isStaffLoggedIn(prefs)) {
      return StaffAppBar(title);
    }
    return AppBar(title: Text(title));
  }

  static String lookupIdFor(ListScreenArgs args) {
    if (args.listType == ListType.zones) {
      return '${args.instituteType == InstituteType.schools ? 1 : 2}';
    }
    return args.zoneId;
  }

  static NavigationTarget onItemTap(
    ListScreenArgs args,
    Zones zone,
    PrefUtils prefs,
  ) {
    if (args.listType == ListType.classes ||
        args.listType == ListType.colleges) {
      if (!isStaffLoggedIn(prefs)) {
        return NavigationTarget(
          route: '/student-details',
          extra: StudentEntity(
            schoolId: int.parse(args.instituteId),
            schoolName: args.instituteName,
            classNo: zone.id,
            className: zone.name,
            state: args.state,
          ),
        );
      }
      return NavigationTarget(
        route: '/students-list',
        extra: nextArgs(args, zone, prefs),
      );
    }
    return NavigationTarget(
      route: '/catalog',
      extra: nextArgs(args, zone, prefs),
    );
  }
}
