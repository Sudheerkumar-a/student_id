import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:student_id/app_routes.dart';
import 'package:student_id/core/utils/pref_utils.dart';

import '../../../core/constants/assets.dart';
import 'list_screen.dart';

class SchoolCollegeScreen extends StatelessWidget {
  const SchoolCollegeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => {
                    PrefUtils()
                        .setBoolValue(SharedPreferencesString.isSchool, true),
                    Navigator.pushNamed(
                      context,
                      AppRoutes.studentTeacherScreen,
                    )
                  },
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
                  onPressed: () => {
                    PrefUtils()
                        .setBoolValue(SharedPreferencesString.isSchool, false),
                    Navigator.pushNamed(
                      context,
                      AppRoutes.studentTeacherScreen,
                    )
                  },
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
