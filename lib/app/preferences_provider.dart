import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/core/utils/pref_utils.dart';

final preferencesProvider = Provider<PrefUtils>((ref) => PrefUtils());
