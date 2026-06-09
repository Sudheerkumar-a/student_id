import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/app/app.dart';
import 'package:student_id/core/utils/pref_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils().init();
  runApp(
    const ProviderScope(
      child: StudentIdApp(),
    ),
  );
}
