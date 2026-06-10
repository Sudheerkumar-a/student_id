import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app/router.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class StudentIdApp extends ConsumerWidget {
  const StudentIdApp({super.key});

  static const _brandPurple = FormTokens.brandPurple;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandPurple,
      brightness: Brightness.light,
      primary: _brandPurple,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(FormTokens.radiusMd),
      borderSide: const BorderSide(color: FormTokens.borderColor),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Student Id',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: FormTokens.surfaceMuted,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimary,
          ),
        ),
        cardTheme: CardThemeData(
          color: colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FormTokens.radiusLg),
            side: const BorderSide(color: FormTokens.borderColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: FormTokens.fieldContentPadding,
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: inputBorder.copyWith(
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: inputBorder.copyWith(
            borderSide: const BorderSide(color: FormTokens.errorColor),
          ),
          focusedErrorBorder: inputBorder.copyWith(
            borderSide: const BorderSide(color: FormTokens.errorColor, width: 2),
          ),
          labelStyle: GoogleFonts.inter(color: FormTokens.textSecondary),
          hintStyle: GoogleFonts.inter(color: FormTokens.textSecondary),
          helperStyle: GoogleFonts.inter(
            fontSize: 12,
            color: FormTokens.textSecondary,
          ),
          errorStyle: GoogleFonts.inter(
            fontSize: 12,
            color: FormTokens.errorColor,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: const Size.fromHeight(FormTokens.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FormTokens.radiusMd),
            ),
          ),
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineSmall: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: FormTokens.textPrimary,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: FormTokens.textPrimary,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            color: FormTokens.textPrimary,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: FormTokens.textSecondary,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            color: FormTokens.textSecondary,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      themeMode: ThemeMode.light,
    );
  }
}
