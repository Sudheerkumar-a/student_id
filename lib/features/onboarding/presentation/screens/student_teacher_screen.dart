import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/core/constants/assets.dart';
import 'package:student_id/features/onboarding/presentation/providers/onboarding_navigation.dart';

class StudentTeacherScreen extends ConsumerWidget {
  const StudentTeacherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 245, 245, 245),
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 20, // Elevation
                      shadowColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(13)) // Shadow Color
                      ),
                  onPressed: () {
                    final prefs = ref.read(preferencesProvider);
                    final target =
                        OnboardingNavigation.catalogEntryForHub(prefs);
                    context.push(target.route, extra: target.extra);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Image.asset(
                          Assets.studentIcon,
                          width: 48,
                          height: 48,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'STUDENTS',
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
                  onPressed: () => {
                    context.push('/login'),
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Image.asset(
                          Assets.teacherICon,
                          width: 48,
                          height: 48,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'TEACHERS',
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 20, // Elevation
                  shadowColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)) // Shadow Color
                  ),
              onPressed: () => {
                context.push('/visitors'),
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Image.asset(
                      Assets.studentIcon,
                      width: 48,
                      height: 48,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'VISITORS',
                      style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
