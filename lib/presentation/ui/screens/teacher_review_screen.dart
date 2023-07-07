import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/presentation/ui/widgets/pic_image_widget.dart';
import 'package:student_id/presentation/ui/widgets/staff_appbar_widget.dart';

import '../../../core/constants/enums.dart';
import '../../../core/errors/error_pop.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/repositories/api_repository_impl.dart';
import '../../../domain/requests/student_request.dart';
import '../../../domain/use_cases/students_usecases.dart';
import '../../bloc/student_list/students_bloc.dart';

class TeacherReviewScreen extends StatefulWidget {
  const TeacherReviewScreen({super.key});

  @override
  State<StatefulWidget> createState() => TeacherReviewScreenState();
}

class TeacherReviewScreenState extends State<TeacherReviewScreen> {
  String _imagePath = '';
  late StudentsBloc _studentsBloc;
  late StudentEntity args;
  void _open_Image_picker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PicImagePopup(_onImageSelected);
        });
  }

  void _onImageSelected(String filePath) {
    if (filePath.isNotEmpty) {
      setState(() {
        _imagePath = filePath;
      });
      _studentsBloc.updateStudentImage(
          studentRequest: StudentRequest(
              id: '${args.id ?? ''}',
              accessToken: PrefUtils()
                      .getStringValue(SharedPreferencesString.accessToken) ??
                  '',
              idPath: filePath));
    }
  }

  Widget _getImageBasedonType(String image) {
    if (image.contains("http://") || image.contains("https://")) {
      return Image.network(image);
    } else if (image.contains('assets/')) {
      return Image.asset(image);
    } else {
      return Image.file(File(image));
    }
  }

  @override
  Widget build(BuildContext context) {
    _studentsBloc = StudentsBloc(
        studentsUsecase:
            StudentsUsecase(repository: context.read<ApisRepositoryImpl>()));
    args = ModalRoute.of(context)!.settings.arguments as StudentEntity;
    if (_imagePath.isEmpty) {
      _imagePath = args.profileUrl ?? 'assets/images/user_profile.png';
    }
    return BlocProvider<StudentsBloc>(
      create: (context) => _studentsBloc,
      child: Scaffold(
        appBar: const StaffAppBar('Student Review Form'),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: BlocListener<StudentsBloc, StudentsState>(
          listener: (context, state) => {
            if (state is StudentsLoading)
              {Dialogs.loader(context)}
            else if (state is UploadIdWithSuccess)
              {
                Navigator.pop(context),
                Dialogs.showInfoDialog(
                    context, 'Alert', state.uploadIdEntitiy.message ?? ''),
              }
            else if (state is StudentsWithError)
              {
                Navigator.pop(context),
                Dialogs.showGenericErrorPopup(
                    context,
                    ErrorPopup(
                        id: 1,
                        errorCode: ErrorHandlerEnum.error_400,
                        title: 'Alert',
                        description: state.message))
              }
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 211, 211, 211),
                  child: _getImageBasedonType(_imagePath),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    'Student Name: ${args.name}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      child: TextButton(
                        onPressed: () {
                          _studentsBloc.updateStudentId(
                              studentRequest: StudentRequest(
                            id: '${args.id ?? 0}',
                            isAccepted: false,
                            accessToken: PrefUtils().getStringValue(
                                    SharedPreferencesString.accessToken) ??
                                '',
                          ));
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                        ),
                        child: const Text('REJECT',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blueAccent,
                      child: TextButton(
                        onPressed: () {
                          _open_Image_picker();
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                        ),
                        child: const Text('EDIT',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.green,
                      child: TextButton(
                        onPressed: () {
                          _studentsBloc.updateStudentId(
                              studentRequest: StudentRequest(
                            id: '${args.id ?? 0}',
                            isAccepted: true,
                            accessToken: PrefUtils().getStringValue(
                                    SharedPreferencesString.accessToken) ??
                                '',
                          ));
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                        ),
                        child: const Text('ACCEPT',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
