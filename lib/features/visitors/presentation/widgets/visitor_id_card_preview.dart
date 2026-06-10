import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_upload_success_shell.dart';

class VisitorIdCardPreview extends StatelessWidget {
  const VisitorIdCardPreview({super.key, required this.studentEntity});

  final StudentEntity studentEntity;

  static Future<void> show(BuildContext context, StudentEntity entity) {
    return AppUploadSuccessShell.show(
      context,
      cardTitle: 'VISITOR ID CARD',
      subtitle: 'Visitor ID card has been created',
      cardBody: VisitorIdCardPreview(studentEntity: entity),
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
        Text(
          studentEntity.name ?? '',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: FormTokens.spacingSm),
        AppIdCardInfoRow(
          label: 'Admission No.',
          value: studentEntity.admissionNumber ?? '',
        ),
        AppIdCardInfoRow(
          label: 'Campus',
          value: studentEntity.schoolName ?? '',
        ),
        AppIdCardInfoRow(
          label: 'Academic Year',
          value: '$year - ${year + 1}',
        ),
      ],
    );
  }
}
