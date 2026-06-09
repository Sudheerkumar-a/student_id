import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/features/auth/presentation/screens/login_screen.dart';
import 'package:student_id/features/camera/presentation/widgets/camera_widget.dart';
import 'package:student_id/features/catalog/presentation/screens/list_screen.dart';
import 'package:student_id/features/onboarding/presentation/screens/school_college_screen.dart';
import 'package:student_id/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:student_id/features/onboarding/presentation/screens/student_teacher_screen.dart';
import 'package:student_id/features/students/presentation/screens/list_students_screen.dart';
import 'package:student_id/features/students/presentation/screens/student_details_screen.dart';
import 'package:student_id/features/students/presentation/screens/student_id_preview_screen.dart';
import 'package:student_id/features/students/presentation/screens/teacher_review_screen.dart';
import 'package:student_id/features/visitors/presentation/screens/visitors_details_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/school-college',
        builder: (context, state) => const SchoolCollegeScreen(),
      ),
      GoRoute(
        path: '/hub',
        builder: (context, state) => const StudentTeacherScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const ListScreen(),
      ),
      GoRoute(
        path: '/student-details',
        builder: (context, state) => const StudentDetailsScreen(),
      ),
      GoRoute(
        path: '/students-list',
        builder: (context, state) => const ListStudentsScreen(),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const TakePictureScreen(),
      ),
      GoRoute(
        path: '/student-preview',
        builder: (context, state) => const StudentIdPreviewScreen(),
      ),
      GoRoute(
        path: '/teacher-review',
        builder: (context, state) => const TeacherReviewScreen(),
      ),
      GoRoute(
        path: '/visitors',
        builder: (context, state) => const VisitorsDetailsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});
