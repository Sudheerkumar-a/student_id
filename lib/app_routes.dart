import 'package:flutter/cupertino.dart';
import 'package:student_id/presentation/ui/screens/list_students_screen.dart';
import 'package:student_id/presentation/ui/screens/student_id_preview_screen.dart';
import 'package:student_id/presentation/ui/screens/visitors_details_screen.dart';
import 'package:student_id/presentation/ui/widgets/camera_widget.dart';
import 'package:student_id/presentation/ui/screens/student_teacher_screen.dart';
import 'package:student_id/presentation/ui/screens/list_screen.dart';
import 'package:student_id/presentation/ui/screens/login_screen.dart';
import 'package:student_id/presentation/ui/screens/school_college_screen.dart';
import 'package:student_id/presentation/ui/screens/splash_screen.dart';
import 'package:student_id/presentation/ui/screens/student_details_screen.dart';
import 'package:student_id/presentation/ui/screens/teacher_review_screen.dart';

class AppRoutes {
  static String initialRoute = '/splash';
  static String studentTeacherScreen = '/student_teacher_screen';
  static String schoolsColleges = '/school_college_screen';
  static String loginScreen = '/login';
  static String listScreen = '/list_screen';
  static String studentDetails = '/student_details';
  static String listStudentsScreen = '/list_students_screen';
  static String takePictureScreen = '/camera_widget';
  static String studentIdPrewviewScreen = '/student_id_preview_screen';
  static String teacherReviewScreen = '/teacher_review_screen';
  static String visitorsDetails = '/visitors_details';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => const SplashScreen(),
      AppRoutes.studentTeacherScreen: (context) => const StudentTeacherScreen(),
      AppRoutes.schoolsColleges: (context) => const SchoolCollegeScreen(),
      AppRoutes.loginScreen: (context) => const LoginScreen(),
      AppRoutes.listScreen: (context) => ListWidget(),
      AppRoutes.studentDetails: (context) => StudentDetails(),
      AppRoutes.visitorsDetails: (context) => VisitorsDetails(),
      AppRoutes.listStudentsScreen: (context) => ListStudents(),
      AppRoutes.takePictureScreen: (context) => const TakePictureScreen(),
      AppRoutes.studentIdPrewviewScreen: (context) => StudentIdPreviewScreen(),
      AppRoutes.teacherReviewScreen: (context) => const TeacherReviewScreen(),
    };
  }
}
