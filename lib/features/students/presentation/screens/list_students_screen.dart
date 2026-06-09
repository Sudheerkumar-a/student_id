import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/shared/presentation/widgets/staff_appbar_widget.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/students/presentation/providers/students_controller.dart';
import 'package:student_id/features/students/presentation/widgets/list_student_item.dart';

class ListStudentsScreen extends ConsumerStatefulWidget {
  const ListStudentsScreen({super.key});

  @override
  ConsumerState<ListStudentsScreen> createState() => _ListStudentsScreenState();
}

class _ListStudentsScreenState extends ConsumerState<ListStudentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStudents());
  }

  void _loadStudents() {
    final args = GoRouterState.of(context).extra! as ListScreenArgs;
    ref.read(studentsControllerProvider.notifier).getStudents(
          StudentRequest(
            loginId:
                PrefUtils().getStringValue(SharedPreferencesString.userName) ??
                    '',
            instituteId: args.instituteId,
            classId: args.classId,
            accessToken: PrefUtils()
                    .getStringValue(SharedPreferencesString.accessToken) ??
                '',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final studentsState = ref.watch(studentsControllerProvider);

    return Scaffold(
      appBar: const StaffAppBar('Students'),
      body: _buildBody(studentsState),
    );
  }

  Widget _buildBody(StudentsState state) {
    if (state.isLoading && state.students.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == StudentsStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Something went wrong',
          style: const TextStyle(color: Colors.black),
        ),
      );
    }

    if (state.status == StudentsStatus.success) {
      return ListView.builder(
        itemCount: state.students.length,
        itemBuilder: (ctx, index) => GestureDetector(
          onTap: () {
            context.push(
              '/teacher-review',
              extra: state.students[index],
            );
          },
          child: ListStudentItem(state.students[index]),
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
