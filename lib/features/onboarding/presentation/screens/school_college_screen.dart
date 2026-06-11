import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/onboarding/presentation/utils/school_college_availability.dart';

class SchoolCollegeScreen extends ConsumerWidget {
  const SchoolCollegeScreen({super.key});

  void _onSchoolSelected(WidgetRef ref, BuildContext context) {
    ref
        .read(preferencesProvider)
        .setBoolValue(SharedPreferencesString.isSchool, true);
    context.push('/hub');
  }

  void _onCollegeSelected(WidgetRef ref, BuildContext context) {
    ref
        .read(preferencesProvider)
        .setBoolValue(SharedPreferencesString.isSchool, false);
    context.push('/hub');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionExpired = SchoolCollegeAvailability.isSelectionExpired;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 245, 245, 245),
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectionExpired)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Text(
                  'School and college registration is no longer available.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 20, // Elevation
                      shadowColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                      disabledBackgroundColor:
                          const Color.fromARGB(255, 230, 230, 230),
                      disabledForegroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(13)) // Shadow Color
                      ),
                  onPressed: selectionExpired
                      ? null
                      : () => _onSchoolSelected(ref, context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.library_books,
                          size: 48,
                        ),
                        Text(
                          'SCHOOLS',
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 20, // Elevation
                      shadowColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(13)) // Shadow Color
                      ),
                  onPressed: selectionExpired
                      ? null
                      : () => _onCollegeSelected(ref, context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.school,
                          size: 48,
                        ),
                        Text(
                          'COLLEGES',
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
