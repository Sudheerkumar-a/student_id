import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:student_id/app_routes.dart';
import 'package:student_id/core/constants/assets.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/presentation/ui/screens/list_screen.dart';

class StudentTeacherScreen extends StatelessWidget {
  const StudentTeacherScreen({super.key});

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
                    Navigator.pushNamed(context, AppRoutes.listScreen,
                        arguments: ListWidgetArguments(
                            PrefUtils().getBoolValue(
                                    SharedPreferencesString.isSchool)
                                ? InstituteType.schools
                                : InstituteType.colleges,
                            ListType.zones))
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
                    Navigator.pushNamed(
                      context,
                      AppRoutes.loginScreen,
                    )
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
          ],
        ),
      ),
    );
  }
}
