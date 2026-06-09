import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/core/constants/enums.dart';
import 'package:student_id/core/errors/error_pop.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/shared/presentation/widgets/staff_appbar_widget.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/students/presentation/models/teacher_review_args.dart';
import 'package:student_id/features/students/presentation/providers/students_controller.dart';
import 'package:student_id/features/camera/presentation/widgets/pic_image_widget.dart';

class TeacherReviewScreen extends ConsumerStatefulWidget {
  const TeacherReviewScreen({super.key});

  @override
  ConsumerState<TeacherReviewScreen> createState() =>
      _TeacherReviewScreenState();
}

class _TeacherReviewScreenState extends ConsumerState<TeacherReviewScreen> {
  String _imagePath = '';
  late TeacherReviewArgs args;

  void _openImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => PicImagePopup(_onImageSelected),
    );
  }

  void _onImageSelected(String filePath) {
    if (filePath.isNotEmpty) {
      setState(() {
        _imagePath = filePath;
      });
      ref.read(studentsControllerProvider.notifier).updateStudentImage(
            StudentRequest(
              id: '${args.studentId ?? ''}',
              accessToken: PrefUtils()
                      .getStringValue(SharedPreferencesString.accessToken) ??
                  '',
              idPath: filePath,
            ),
          );
    }
  }

  Widget _getImageBasedOnType(String image) {
    if (image.contains('http://') || image.contains('https://')) {
      return Image.network(image);
    }
    if (image.contains('assets/')) {
      return Image.asset(image);
    }
    return Image.file(File(image));
  }

  @override
  Widget build(BuildContext context) {
    args = TeacherReviewArgs.fromExtra(GoRouterState.of(context).extra!);
    if (_imagePath.isEmpty) {
      _imagePath = args.imagePath;
    }

    ref.listen(studentsControllerProvider, (previous, next) {
      if (next.status == StudentsStatus.loading) {
        Dialogs.loader(context);
      } else if (next.status == StudentsStatus.uploadSuccess) {
        context.pop();
        Dialogs.showInfoDialog(
          context,
          'Alert',
          next.uploadResult?.message ?? '',
        );
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

    return Scaffold(
      appBar: const StaffAppBar('Student Review Form'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 211, 211, 211),
              child: _getImageBasedOnType(_imagePath),
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: TextButton(
                    onPressed: () {
                      ref
                          .read(studentsControllerProvider.notifier)
                          .updateStudentId(
                            StudentRequest(
                              id: '${args.studentId ?? 0}',
                              isAccepted: false,
                              accessToken: PrefUtils().getStringValue(
                                    SharedPreferencesString.accessToken,
                                  ) ??
                                  '',
                            ),
                          );
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'REJECT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.blueAccent,
                  child: TextButton(
                    onPressed: _openImagePicker,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'EDIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  child: TextButton(
                    onPressed: () {
                      ref
                          .read(studentsControllerProvider.notifier)
                          .updateStudentId(
                            StudentRequest(
                              id: '${args.studentId ?? 0}',
                              isAccepted: true,
                              accessToken: PrefUtils().getStringValue(
                                    SharedPreferencesString.accessToken,
                                  ) ??
                                  '',
                            ),
                          );
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'ACCEPT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
