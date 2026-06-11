import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/core/constants/enums.dart';
import 'package:student_id/core/errors/error_pop.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/catalog/presentation/utils/zone_state_filter.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/students/presentation/providers/students_controller.dart';
import 'package:student_id/features/students/presentation/widgets/college_id_card_preview.dart';
import 'package:student_id/features/students/presentation/widgets/school_id_card_preview.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_scaffold.dart';

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
    final studentsState = ref.watch(studentsControllerProvider);
    final isStaff = args.className == 'STAFF';

    ref.listen(studentsControllerProvider, (previous, next) async {
      if (next.status == StudentsStatus.loading) {
        Dialogs.loader(context, message: 'Uploading ID card...');
      } else if (next.status == StudentsStatus.uploadSuccess) {
        if (context.mounted) Navigator.pop(context);
        if (_isCollegeClass(args)) {
          await CollegeIdCardPreview.show(context, args);
        } else {
          await SchoolIdCardPreview.show(context, args);
        }
        if (context.mounted) {
          context.pop();
          context.pop();
          context.pop();
        }
      } else if (next.status == StudentsStatus.error) {
        if (context.mounted) Navigator.pop(context);
        Dialogs.showGenericErrorPopup(
          context,
          ErrorPopup(
            id: 1,
            errorCode: ErrorHandlerEnum.error_400,
            title: 'Upload Failed',
            description: next.errorMessage ?? '',
          ),
        );
      }
    });

    return AppFormScaffold(
      title: 'Photo Preview',
      subtitle: 'Review before submitting',
      bottomLabel: 'Upload ID Card',
      bottomLoading: studentsState.isLoading,
      onBottomPressed: () {
        ref.read(studentsControllerProvider.notifier).uploadStudentId(
              StudentRequest(
                loginId: PrefUtils()
                        .getStringValue(SharedPreferencesString.userName) ??
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
      body: Column(
        children: [
          AppFormSectionCard(
            title: 'Captured Photo',
            subtitle: 'Ensure face is clear and background is plain',
            icon: Icons.photo_camera_outlined,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(FormTokens.radiusMd),
                child: Image.file(
                  File(args.profileUrl!),
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const AppFieldGap(size: FormTokens.spacingLg),
          AppFormSectionCard(
            title: 'Details Summary',
            icon: Icons.summarize_outlined,
            children: [
              if (!_isCollegeClass(args) || isStaff)
                _SummaryRow(
                  icon: Icons.person_outline,
                  label: isStaff ? 'Teacher Name' : 'Student Name',
                  value: args.name ?? '',
                ),
              _SummaryRow(
                icon: Icons.badge_outlined,
                label: 'Admission Number',
                value: args.admissionNumber ?? '',
              ),
              if (ZoneStateFilter.isTelangana(args.state))
                _SummaryRow(
                  icon: Icons.family_restroom_outlined,
                  label: 'Parent Name',
                  value: args.parentName ?? '',
                ),
              if (args.schoolName?.isNotEmpty == true)
                _SummaryRow(
                  icon: Icons.school_outlined,
                  label: 'Institute',
                  value: args.schoolName ?? '',
                ),
            ],
          ),
          const AppFieldGap(size: FormTokens.spacingXl),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FormTokens.spacingSm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: FormTokens.textSecondary),
          const SizedBox(width: FormTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: FormTokens.textSecondary,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
