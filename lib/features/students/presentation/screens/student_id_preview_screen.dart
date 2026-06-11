import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/core/constants/enums.dart';
import 'package:student_id/core/errors/error_pop.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/students/presentation/providers/students_controller.dart';
import 'package:student_id/features/students/presentation/widgets/college_id_card_preview.dart';
import 'package:student_id/features/students/presentation/widgets/school_id_card_preview.dart';

class StudentIdPreviewScreen extends ConsumerWidget {
  const StudentIdPreviewScreen({super.key});

  bool _isCollegeClass(StudentEntity args) {
    return args.classNo == 'FIRST_YEAR' ||
        args.classNo == 'SECOND_YEAR' ||
        args.classNo == 'LONG_TERM';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = GoRouterState.of(context).extra! as StudentEntity;

    ref.listen(studentsControllerProvider, (previous, next) async {
      if (next.status == StudentsStatus.loading) {
        Dialogs.loader(context);
      } else if (next.status == StudentsStatus.uploadSuccess) {
        Widget idCard = SchoolIdCardPreview(args);
        if (_isCollegeClass(args)) {
          idCard = CollegeIdCardPreview(args);
        }
        await showDialog(context: context, builder: (context) => idCard);
        if (context.mounted) {
          context.pop();
          context.pop();
          context.pop();
        }
      } else if (next.status == StudentsStatus.error) {
        context.pop();
        Dialogs.showGenericErrorPopup(
          context,
          ErrorPopup(
            id: 1,
            errorCode: ErrorHandlerEnum.error_400,
            title: 'Alert',
            description: next.errorMessage ?? '',
          ),
        );
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Picture Preview')),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 211, 211, 211),
                child: Image.file(File(args.profileUrl!)),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                if (!_isCollegeClass(args) || args.className == 'STAFF') ...{
                  Text(
                    args.className == 'STAFF'
                        ? 'Teacher Name: ${args.name}'
                        : 'Student Name: ${args.name}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                },
                Text(
                  'Admission Number: ${args.admissionNumber}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                if (args.parentName?.isNotEmpty == true) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Parent Name: ${args.parentName}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: TextButton(
                onPressed: () {
                  ref.read(studentsControllerProvider.notifier).uploadStudentId(
                        StudentRequest(
                          loginId: PrefUtils().getStringValue(
                                SharedPreferencesString.userName,
                              ) ??
                              '',
                          zoneId: '1',
                          instituteId: '${args.schoolId ?? ''}',
                          classId: args.classNo ?? '',
                          sectionName: args.sectionName ?? '',
                          studentName: args.name ?? '',
                          admissionNumber: args.admissionNumber ?? '',
                          idPath: args.profileUrl ?? '',
                          transport: args.transport ?? '',
                          parentName: args.parentName ?? '',
                        ),
                      );
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  ),
                ),
                child: const Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
