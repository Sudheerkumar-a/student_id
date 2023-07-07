import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/data/repositories/api_repository_impl.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/domain/requests/student_request.dart';
import 'package:student_id/domain/use_cases/students_usecases.dart';
import 'package:student_id/presentation/bloc/student_list/students_bloc.dart';
import 'package:student_id/presentation/ui/widgets/college_id_card_preview.dart';

import '../../../app_routes.dart';
import '../../../core/constants/enums.dart';
import '../../../core/errors/error_pop.dart';
import '../../../core/utils/dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as Img;

import '../widgets/school_id_card_preview.dart';

class StudentIdPreviewScreen extends StatelessWidget {
  StudentIdPreviewScreen({super.key});
  late StudentsBloc _studentsBloc;

  @override
  Widget build(BuildContext context) {
    _studentsBloc = StudentsBloc(
        studentsUsecase:
            StudentsUsecase(repository: context.read<ApisRepositoryImpl>()));
    var args = ModalRoute.of(context)!.settings.arguments as StudentEntity;
    return BlocProvider<StudentsBloc>(
      create: (context) => _studentsBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Picture Preview')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: BlocListener<StudentsBloc, StudentsState>(
          listener: (context, state) async {
            if (state is StudentsLoading) {
              Dialogs.loader(context);
            } else if (state is UploadIdWithSuccess) {
              // await Dialogs.showInfoDialog(
              //     context, 'Alert', state.uploadIdEntitiy.message ?? ''),
              Widget idCard = SchoolIdCardPreview(args);
              if (args.classNo == 'FIRST_YEAR' ||
                  args.classNo == 'SECOND_YEAR') {
                idCard = CollegeIdCardPreview(args);
              }
              await showDialog(context: context, builder: (context) => idCard);
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.studentTeacherScreen,
                  (Route<dynamic> route) => false,
                );
              }
            } else if (state is StudentsWithError) {
              Navigator.pop(context);
              Dialogs.showGenericErrorPopup(
                  context,
                  ErrorPopup(
                      id: 1,
                      errorCode: ErrorHandlerEnum.error_400,
                      title: 'Alert',
                      description: state.message));
            }
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 211, 211, 211),
                  child: Image.file(File(args.profileUrl!)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
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
                  Text(
                    'Admission Number: ${args.admissionNumber}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                //padding: const EdgeInsets.all(10),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: TextButton(
                  onPressed: () {
                    _studentsBloc.uploadStudentId(
                        studentRequest: StudentRequest(
                            loginId: PrefUtils().getStringValue(
                                    SharedPreferencesString.userName) ??
                                '',
                            zoneId: '1',
                            instituteId: '${args.schoolId ?? ''}',
                            classId: args.classNo ?? '',
                            studentName: args.name ?? '',
                            admissionNumber: args.admissionNumber ?? '',
                            idPath: args.profileUrl ?? '',
                            transport: args.transport ?? ''));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                  ),
                  child: const Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
