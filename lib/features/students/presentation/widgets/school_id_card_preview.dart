import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_upload_success_shell.dart';

class SchoolIdCardPreview extends StatelessWidget {
  const SchoolIdCardPreview({super.key, required this.studentEntity});

  final StudentEntity studentEntity;

  static Future<void> show(BuildContext context, StudentEntity entity) {
    final isStaff = entity.className == 'STAFF';
    return AppUploadSuccessShell.show(
      context,
      cardTitle: isStaff ? 'TEACHER ID CARD' : 'STUDENT ID CARD',
      cardBody: SchoolIdCardPreview(studentEntity: entity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStaff = studentEntity.className == 'STAFF';

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
        AppIdCardInfoRow(label: 'Name', value: studentEntity.name ?? ''),
        if (!isStaff)
          AppIdCardInfoRow(
            label: 'Class',
            value: studentEntity.className ?? '',
          ),
        AppIdCardInfoRow(
          label: isStaff ? 'Staff ID' : 'Student ID',
          value: studentEntity.admissionNumber ?? '',
        ),
        AppIdCardInfoRow(
          label: 'Branch',
          value: studentEntity.schoolName ?? '',
        ),
      ],
    );
  }
}
