import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/students/presentation/providers/students_controller.dart';
import 'package:student_id/features/students/presentation/widgets/list_student_item.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/lists/app_list_state_view.dart';
import 'package:student_id/shared/presentation/widgets/staff_appbar_widget.dart';

class ListStudentsScreen extends ConsumerStatefulWidget {
  const ListStudentsScreen({super.key});

  @override
  ConsumerState<ListStudentsScreen> createState() => _ListStudentsScreenState();
}

class _ListStudentsScreenState extends ConsumerState<ListStudentsScreen> {
  late ListScreenArgs _args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStudents());
  }

  void _loadStudents() {
    _args = GoRouterState.of(context).extra! as ListScreenArgs;
    ref.read(studentsControllerProvider.notifier).getStudents(
          StudentRequest(
            loginId: PrefUtils()
                    .getStringValue(SharedPreferencesString.userName) ??
                '',
            instituteId: _args.instituteId,
            classId: _args.classId,
            accessToken: PrefUtils()
                    .getStringValue(SharedPreferencesString.accessToken) ??
                '',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final studentsState = ref.watch(studentsControllerProvider);
    final args = GoRouterState.of(context).extra! as ListScreenArgs;

    return Scaffold(
      backgroundColor: FormTokens.surfaceMuted,
      appBar: StaffAppBar(
        args.instituteName.isNotEmpty ? args.instituteName : 'Students',
      ),
      body: _buildBody(studentsState, args),
    );
  }

  Widget _buildBody(StudentsState state, ListScreenArgs args) {
    if (state.isLoading && state.students.isEmpty) {
      return const AppListLoadingView(message: 'Loading students...');
    }

    if (state.status == StudentsStatus.error) {
      return AppListErrorView(
        message: state.errorMessage ?? 'Something went wrong',
        onRetry: _loadStudents,
      );
    }

    if (state.status == StudentsStatus.success && state.students.isEmpty) {
      return const AppListEmptyView(
        title: 'No students found',
        message: 'There are no student records for this class yet.',
        icon: Icons.people_outline,
      );
    }

    if (state.status == StudentsStatus.success) {
      return SingleChildScrollView(
        padding: FormTokens.screenPadding.copyWith(
          bottom: FormTokens.spacingXl,
        ),
        child: AppFormSectionCard(
          title: 'Student List',
          subtitle: '${state.students.length} student(s) — tap to review',
          icon: Icons.people_outline,
          children: state.students
              .map(
                (student) => GestureDetector(
                  onTap: () => context.push(
                    '/teacher-review',
                    extra: student,
                  ),
                  child: ListStudentItem(student),
                ),
              )
              .toList(),
        ),
      );
    }

    return const AppListLoadingView();
  }
}
