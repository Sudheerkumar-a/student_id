import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/data/repositories/api_repository_impl.dart';
import 'package:student_id/domain/requests/student_request.dart';
import 'package:student_id/domain/use_cases/students_usecases.dart';
import 'package:student_id/presentation/ui/widgets/list_student_item.dart';
import 'package:student_id/presentation/ui/widgets/staff_appbar_widget.dart';

import '../../../app_routes.dart';
import '../../bloc/student_list/students_bloc.dart';
import 'list_screen.dart';

class ListStudents extends StatelessWidget {
  ListStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final _agrs =
        ModalRoute.of(context)!.settings.arguments as ListWidgetArguments;

    return BlocProvider<StudentsBloc>(
      create: (context) => StudentsBloc(
          studentsUsecase:
              StudentsUsecase(repository: context.read<ApisRepositoryImpl>()))
        ..getStudents(
            studentRequest: StudentRequest(
                loginId: PrefUtils().getStringValue('user_name') ?? '',
                instituteId: _agrs.instituteId,
                classId: _agrs.classID,
                accessToken: PrefUtils()
                        .getStringValue(SharedPreferencesString.accessToken) ??
                    '')),
      child: Scaffold(
        appBar: const StaffAppBar('Students'),
        body:
            BlocBuilder<StudentsBloc, StudentsState>(builder: (context, state) {
          if (state is StudentsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StudentsWithSuccess) {
            return ListView.builder(
              itemCount: state.studentEntity.length,
              itemBuilder: (ctx, index) => GestureDetector(
                  onTap: () => {
                        Navigator.pushNamed(
                            context, AppRoutes.teacherReviewScreen,
                            arguments: state.studentEntity[index])
                      },
                  child: ListStudentItem(state.studentEntity[index])),
            );
          } else if (state is StudentsWithError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
