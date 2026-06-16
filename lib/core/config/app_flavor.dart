/// App flavor from `--flavor` builds (`FLUTTER_APP_FLAVOR` dart-define).
abstract final class AppFlavor {
  static const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');

  static bool get isGeneric => flavor == 'generic';
}
