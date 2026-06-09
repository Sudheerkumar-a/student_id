import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';
import 'package:student_id/shared/navigation/navigation_target.dart';

class OnboardingNavigation {
  static NavigationTarget resolveAfterSplash(PrefUtils prefs) {
    final username =
        prefs.getStringValue(SharedPreferencesString.userName) ?? '';
    if (username.isEmpty) {
      return const NavigationTarget(route: '/school-college');
    }
    return const NavigationTarget(
      route: '/catalog',
      extra: ListScreenArgs(
        InstituteType.schools,
        ListType.classes,
      ),
    );
  }

  static NavigationTarget catalogEntryForHub(PrefUtils prefs) {
    final isSchool =
        prefs.getBoolValue(SharedPreferencesString.isSchool);
    return NavigationTarget(
      route: '/catalog',
      extra: ListScreenArgs(
        isSchool ? InstituteType.schools : InstituteType.colleges,
        ListType.zones,
      ),
    );
  }
}
