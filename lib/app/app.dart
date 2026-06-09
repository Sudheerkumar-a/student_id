import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app/router.dart';

class StudentIdApp extends ConsumerWidget {
  const StudentIdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final colorScheme =
        ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));
    final darkColorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 5, 99, 125),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Student Id',
      routerConfig: router,
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        cardTheme: CardThemeData(
          color: darkColorScheme.secondaryContainer,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColorScheme.primaryContainer,
            foregroundColor: darkColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: const TextTheme().copyWith(
          titleLarge: TextStyle(
            color: darkColorScheme.onSecondaryContainer,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.onPrimaryContainer,
          foregroundColor: colorScheme.primaryContainer,
        ),
        cardTheme: CardThemeData(color: colorScheme.secondaryContainer),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
          ),
        ),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      themeMode: ThemeMode.light,
    );
  }
}
