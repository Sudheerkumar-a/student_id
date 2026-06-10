import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_upload_success_shell.dart';

class CollegeIdCardPreview extends StatelessWidget {
  const CollegeIdCardPreview({super.key, required this.studentEntity});

  final StudentEntity studentEntity;

  static Future<void> show(BuildContext context, StudentEntity entity) {
    return AppUploadSuccessShell.show(
      context,
      cardTitle: 'IDENTITY CARD',
      cardBody: CollegeIdCardPreview(studentEntity: entity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(FormTokens.radiusMd),
          child: Image.file(
            File(studentEntity.profileUrl!),
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: FormTokens.spacingSm),
        AppIdCardInfoRow(
          label: 'Admin No.',
          value: studentEntity.admissionNumber ?? '',
        ),
        AppIdCardInfoRow(
          label: 'Section',
          value: studentEntity.sectionName ?? '',
        ),
        AppIdCardInfoRow(
          label: 'Campus',
          value: studentEntity.schoolName ?? '',
        ),
        AppIdCardInfoRow(
          label: 'Academic Year',
          value: '$year - ${year + 1}',
        ),
        AppIdCardInfoRow(
          label: 'Transport',
          value: studentEntity.transport ?? '',
        ),
      ],
    );
  }
}
