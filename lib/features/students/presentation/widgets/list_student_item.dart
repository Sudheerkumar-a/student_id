import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class ListStudentItem extends StatelessWidget {
  const ListStudentItem(this.studentEntity, {super.key});

  final StudentEntity studentEntity;

  Color _statusColor(String? status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green.shade600;
      case 'REJECTED':
        return FormTokens.errorColor;
      default:
        return FormTokens.textSecondary;
    }
  }

  Widget _avatar(String image) {
    if (image.contains('http://') || image.contains('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(FormTokens.radiusMd),
        child: Image.network(image, width: 56, height: 56, fit: BoxFit.cover),
      );
    }
    if (image.contains('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(FormTokens.radiusMd),
        child: Image.asset(image, width: 56, height: 56, fit: BoxFit.cover),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(FormTokens.radiusMd),
      child: Image.file(File(image), width: 56, height: 56, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = studentEntity.infoStatus ?? 'PENDING';
    final statusColor = _statusColor(studentEntity.infoStatus);

    return Padding(
      padding: const EdgeInsets.only(bottom: FormTokens.spacingSm),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(FormTokens.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(FormTokens.spacingMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FormTokens.radiusMd),
            border: Border.all(color: FormTokens.borderColor),
          ),
          child: Row(
            children: [
              _avatar(studentEntity.profileUrl ?? 'assets/images/user_profile.png'),
              const SizedBox(width: FormTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentEntity.name ?? '',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      studentEntity.admissionNumber ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FormTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: FormTokens.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FormTokens.spacingSm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(FormTokens.radiusMd),
                      ),
                      child: Text(
                        status,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
