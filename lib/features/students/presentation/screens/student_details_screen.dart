import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/presentation/providers/student_details_helper.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_photo_flow.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_scaffold.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_radio_option_group.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_text_field.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _anTextController = TextEditingController();
  final _sectionTextController = TextEditingController();
  final _parentNameTextController = TextEditingController();

  String? _transportType = 'own';
  late StudentEntity args;

  bool get _isCollege => StudentDetailsHelper.isCollegeStudent(args);
  bool get _isStaff => StudentDetailsHelper.isStaff(args);
  bool get _isTelangana => StudentDetailsHelper.isTelangana(args);

  bool get _canContinue {
    final admissionFilled = _anTextController.text.trim().isNotEmpty;
    final nameFilled =
        _isCollege && !_isStaff || _nameTextController.text.trim().isNotEmpty;
    final parentFilled =
        !_isTelangana || _parentNameTextController.text.trim().isNotEmpty;
    return admissionFilled && nameFilled && parentFilled;
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _anTextController.dispose();
    _sectionTextController.dispose();
    _parentNameTextController.dispose();
    super.dispose();
  }

  Future<void> _continueToPhoto() async {
    if (_formKey.currentState?.validate() != true) return;

    await AppPhotoFlow.pickPhoto(context, _onImageSelected);
  }

  void _onImageSelected(String filePath) {
    if (filePath.isEmpty) return;

    context.push(
      '/student-preview',
      extra: StudentDetailsHelper.buildPreviewEntity(
        args: args,
        name: _nameTextController.text,
        admissionNumber: _anTextController.text,
        sectionName: _sectionTextController.text,
        transportType: _transportType,
        photoPath: filePath,
        parentName: _parentNameTextController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    args = GoRouterState.of(context).extra! as StudentEntity;

    return AppFormScaffold(
      title: 'Student Details',
      subtitle: args.schoolName?.isNotEmpty == true ? args.schoolName : null,
      bottomLabel: 'Continue to Photo',
      bottomEnabled: _canContinue,
      onBottomPressed: _continueToPhoto,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            AppFormSectionCard(
              title: 'Personal Information',
              subtitle: 'Enter student identification details',
              icon: Icons.person_outline,
              children: [
                if (!_isCollege || _isStaff) ...[
                  AppTextField(
                    controller: _nameTextController,
                    label: _isStaff ? 'Teacher Name' : 'Student Name',
                    icon: Icons.badge_outlined,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]')),
                    ],
                    validator: (v) =>
                        v?.trim().isEmpty == true ? 'Please enter name' : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const AppFieldGap(size: FormTokens.spacingSm),
                  const AppHelperBanner(
                    text:
                        'Example: Chinta Vera Venkata Naga Kishore Kumar\nShort form: Chinta V.V.N. Kishore Kumar',
                  ),
                  const AppFieldGap(),
                ],
                AppTextField(
                  controller: _anTextController,
                  label: 'Admission ID',
                  hint: 'Enter admission number',
                  icon: Icons.numbers_rounded,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
                  ],
                  validator: (v) => v?.trim().isEmpty == true
                      ? 'Please enter admission ID'
                      : null,
                  onChanged: (_) => setState(() {}),
                ),
                if (_isTelangana) ...[
                  const AppFieldGap(),
                  AppTextField(
                    controller: _parentNameTextController,
                    label: 'Parent Name',
                    hint: 'Enter parent or guardian name',
                    icon: Icons.family_restroom_outlined,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]')),
                    ],
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => v?.trim().isEmpty == true
                        ? 'Please enter parent name'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
                if (_isCollege && _isStaff) ...[
                  const AppFieldGap(),
                  AppTextField(
                    controller: _sectionTextController,
                    label: 'Section',
                    icon: Icons.grid_view_rounded,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
                    ],
                    validator: (v) =>
                        v?.trim().isEmpty == true ? 'Please enter section' : null,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ],
            ),
            if (!_isCollege || _isStaff) ...[
              const AppFieldGap(size: FormTokens.spacingLg),
              AppFormSectionCard(
                title: 'Transport',
                subtitle: 'How does the student commute?',
                icon: Icons.directions_bus_outlined,
                children: [
                  AppRadioOptionGroup<String>(
                    title: 'Transport Type',
                    groupValue: _transportType,
                    onChanged: (v) => setState(() => _transportType = v),
                    options: const [
                      AppRadioOption(
                        value: 'own',
                        label: 'Own Transport',
                        icon: Icons.directions_car_outlined,
                      ),
                      AppRadioOption(
                        value: 'institute',
                        label: 'Institute Transport',
                        icon: Icons.directions_bus_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ],
            const AppFieldGap(size: FormTokens.spacingXl),
          ],
        ),
      ),
    );
  }
}
