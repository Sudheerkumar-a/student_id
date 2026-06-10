import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/visitors/domain/requests/visitor_request.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_photo_flow.dart';
import 'package:student_id/features/visitors/presentation/providers/visitors_controller.dart';
import 'package:student_id/features/visitors/presentation/widgets/visitor_id_card_preview.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_dropdown_field.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_scaffold.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_photo_upload_card.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_primary_button.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_text_field.dart';

class VisitorsDetailsScreen extends ConsumerStatefulWidget {
  const VisitorsDetailsScreen({super.key});

  @override
  ConsumerState<VisitorsDetailsScreen> createState() =>
      _VisitorsDetailsScreenState();
}

class _VisitorsDetailsScreenState extends ConsumerState<VisitorsDetailsScreen> {
  final _nameTextController = TextEditingController();
  final _anTextController = TextEditingController();
  final _sectionTextController = TextEditingController();
  final _visitorNameTextController = TextEditingController();
  final _contactNoTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _visitorPhotoPath = '';
  String? _relationship;
  Zones? _selectedZone;
  Zones? _selectedInstitute;
  Zones? _selectedClass;
  bool _studentDetailsFetched = false;

  static const _relations = ['Father', 'Mother', 'Visitor'];

  @override
  void dispose() {
    _nameTextController.dispose();
    _anTextController.dispose();
    _sectionTextController.dispose();
    _visitorNameTextController.dispose();
    _contactNoTextController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _selectedInstitute != null &&
      _selectedClass != null &&
      _relationship != null &&
      _relationship!.isNotEmpty &&
      _visitorPhotoPath.isNotEmpty &&
      _nameTextController.text.trim().isNotEmpty &&
      _sectionTextController.text.trim().isNotEmpty &&
      _visitorNameTextController.text.trim().isNotEmpty &&
      _anTextController.text.trim().isNotEmpty;

  InstituteType get _instituteType =>
      PrefUtils().getBoolValue(SharedPreferencesString.isSchool)
          ? InstituteType.schools
          : InstituteType.colleges;

  String get _schoolLabel =>
      _instituteType == InstituteType.schools ? 'School' : 'College';

  String get _classLabel =>
      _instituteType == InstituteType.schools ? 'Class' : 'Year';

  Future<void> _fetchStudentDetails() async {
    if (_selectedInstitute == null || _selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select $_schoolLabel and $_classLabel first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_anTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter admission number'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final student = await ref.read(visitorsControllerProvider.notifier).lookupStudent(
          StudentRequest(
            instituteId: '${_selectedInstitute?.id}'.trim(),
            classId: '${_selectedClass?.id}'.trim(),
            admissionNumber: _anTextController.text.trim(),
          ),
        );

    if (!mounted) return;

    final visitorsState = ref.read(visitorsControllerProvider);
    if (visitorsState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(visitorsState.errorMessage!),
          behavior: SnackBarBehavior.floating,
          backgroundColor: FormTokens.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _studentDetailsFetched = student.name?.isNotEmpty == true;
      _nameTextController.text = student.name ?? '';
      _sectionTextController.text = student.sectionName ?? '';
    });
  }

  Future<void> _pickVisitorPhoto() async {
    await AppPhotoFlow.pickPhoto(context, (path) {
      if (path.isNotEmpty) {
        setState(() => _visitorPhotoPath = path);
      }
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true || !_canSubmit) return;

    final visitorRequest = VisitorRequest(
      admissionNumber: _anTextController.text.trim(),
      visitorName: _visitorNameTextController.text.trim(),
      relationship: _relationship!,
      studentName: _nameTextController.text.trim(),
      sectionName: _sectionTextController.text.trim(),
      instituteId: '${_selectedInstitute?.id}',
      classId: '${_selectedClass?.id}',
      contactNumber: _contactNoTextController.text.trim(),
      photoPath: _visitorPhotoPath,
    );

    final response = await ref
        .read(visitorsControllerProvider.notifier)
        .uploadVisitor(visitorRequest);

    if (!mounted) return;

    final visitorsState = ref.read(visitorsControllerProvider);
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(visitorsState.errorMessage ?? 'Submission failed'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: FormTokens.errorColor,
        ),
      );
      return;
    }

    await VisitorIdCardPreview.show(
      context,
      StudentEntity(
        name: _visitorNameTextController.text,
        schoolName: _selectedInstitute?.name ?? '',
        admissionNumber: _anTextController.text,
        profileUrl: _visitorPhotoPath,
      ),
    );
    if (mounted) context.go('/hub');
  }

  @override
  Widget build(BuildContext context) {
    final visitorsState = ref.watch(visitorsControllerProvider);

    final zonesAsync = ref.watch(
      catalogItemsProvider(
        CatalogQuery(
          listType: ListType.zones,
          lookupId: _instituteType == InstituteType.schools ? '1' : '2',
        ),
      ),
    );

    final institutesAsync = _selectedZone == null
        ? const AsyncValue<List<Zones>>.data([])
        : ref.watch(
            catalogItemsProvider(
              CatalogQuery(
                listType: ListType.institutes,
                lookupId: '${_selectedZone?.id}',
              ),
            ),
          );

    final classesAsync = ref.watch(
      catalogItemsProvider(
        CatalogQuery(
          listType: _instituteType == InstituteType.schools
              ? ListType.classes
              : ListType.colleges,
        ),
      ),
    );

    return AppFormScaffold(
      title: 'Visitor Details',
      subtitle: 'Register a school visitor',
      bottomLabel: 'Submit Visitor',
      bottomEnabled: _canSubmit,
      bottomLoading: visitorsState.isSubmitting,
      onBottomPressed: _submit,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            AppFormSectionCard(
              title: 'Student Information',
              subtitle: 'Select school details and verify student',
              icon: Icons.school_outlined,
              children: [
                zonesAsync.when(
                  data: (items) => AppDropdownField<Zones>(
                    label: 'Zone',
                    hint: 'Select zone',
                    icon: Icons.map_outlined,
                    items: items,
                    value: _selectedZone,
                    itemLabel: (z) => z.name ?? z.toString(),
                    onChanged: (value) => setState(() {
                      _selectedZone = value;
                      _selectedInstitute = null;
                      _studentDetailsFetched = false;
                    }),
                  ),
                  loading: () => AppDropdownField<Zones>(
                    label: 'Zone',
                    items: const [],
                    itemLabel: _zoneLabel,
                    isLoading: true,
                  ),
                  error: (e, _) => AppDropdownField<Zones>(
                    label: 'Zone',
                    items: const [],
                    itemLabel: _zoneLabel,
                    errorMessage: '$e',
                  ),
                ),
                const AppFieldGap(),
                institutesAsync.when(
                  data: (items) => AppDropdownField<Zones>(
                    label: _schoolLabel,
                    hint: 'Select $_schoolLabel',
                    icon: Icons.account_balance_outlined,
                    items: items,
                    value: _selectedInstitute,
                    enabled: _selectedZone != null,
                    itemLabel: (z) => z.name ?? z.toString(),
                    validator: (v) =>
                        v == null ? 'Please select $_schoolLabel' : null,
                    onChanged: (value) => setState(() {
                      _selectedInstitute = value;
                      _studentDetailsFetched = false;
                    }),
                  ),
                  loading: () => AppDropdownField<Zones>(
                    label: _schoolLabel,
                    items: const [],
                    itemLabel: _zoneLabel,
                    isLoading: true,
                    enabled: _selectedZone != null,
                  ),
                  error: (e, _) => AppDropdownField<Zones>(
                    label: _schoolLabel,
                    items: const [],
                    itemLabel: _zoneLabel,
                    errorMessage: '$e',
                  ),
                ),
                const AppFieldGap(),
                classesAsync.when(
                  data: (items) => AppDropdownField<Zones>(
                    label: _classLabel,
                    hint: 'Select $_classLabel',
                    icon: Icons.class_outlined,
                    items: items,
                    value: _selectedClass,
                    itemLabel: (z) => z.name ?? z.toString(),
                    validator: (v) =>
                        v == null ? 'Please select $_classLabel' : null,
                    onChanged: (value) => setState(() {
                      _selectedClass = value;
                      _studentDetailsFetched = false;
                    }),
                  ),
                  loading: () => AppDropdownField<Zones>(
                    label: _classLabel,
                    items: const [],
                    itemLabel: _zoneLabel,
                    isLoading: true,
                  ),
                  error: (e, _) => AppDropdownField<Zones>(
                    label: _classLabel,
                    items: const [],
                    itemLabel: _zoneLabel,
                    errorMessage: '$e',
                  ),
                ),
                const AppFieldGap(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _anTextController,
                        label: 'Admission Number',
                        hint: 'e.g. TEST4545',
                        icon: Icons.badge_outlined,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9a-zA-Z. ]'),
                          ),
                        ],
                        validator: (v) =>
                            v?.trim().isEmpty == true ? 'Required' : null,
                        onChanged: (_) => setState(() {
                          _studentDetailsFetched = false;
                        }),
                      ),
                    ),
                    const SizedBox(width: FormTokens.spacingSm),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: AppPrimaryButton(
                        label: 'Get',
                        compact: true,
                        icon: Icons.search_rounded,
                        isLoading: visitorsState.isLookingUp,
                        onPressed: visitorsState.isLookingUp
                            ? null
                            : _fetchStudentDetails,
                      ),
                    ),
                  ],
                ),
                const AppFieldGap(size: FormTokens.spacingSm),
                const AppHelperBanner(
                  text: 'Example admission number: TEST4545',
                  icon: Icons.lightbulb_outline_rounded,
                ),
                const AppFieldGap(),
                AppTextField(
                  controller: _nameTextController,
                  label: 'Student Name',
                  icon: Icons.person_outline,
                  readOnly: _studentDetailsFetched,
                  helperText: _studentDetailsFetched
                      ? 'Auto-filled from admission record'
                      : 'Fetch details using admission number',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ]')),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Required' : null,
                ),
                const AppFieldGap(),
                AppTextField(
                  controller: _sectionTextController,
                  label: 'Section',
                  icon: Icons.grid_view_rounded,
                  readOnly: _studentDetailsFetched,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Required' : null,
                ),
              ],
            ),
            const AppFieldGap(size: FormTokens.spacingLg),
            AppFormSectionCard(
              title: 'Visitor Information',
              subtitle: 'Details of the person visiting',
              icon: Icons.person_pin_outlined,
              children: [
                AppDropdownField<String>(
                  label: 'Visitor Relation',
                  hint: 'Select relation',
                  icon: Icons.family_restroom_outlined,
                  items: _relations,
                  value: _relationship,
                  itemLabel: (v) => v,
                  validator: (v) => v == null ? 'Please select relation' : null,
                  onChanged: (v) => setState(() => _relationship = v),
                ),
                const AppFieldGap(),
                AppTextField(
                  controller: _visitorNameTextController,
                  label: 'Visitor Name',
                  icon: Icons.person_outline,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ]')),
                  ],
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Required' : null,
                  onChanged: (_) => setState(() {}),
                ),
                const AppFieldGap(),
                AppTextField(
                  controller: _contactNoTextController,
                  label: 'Contact Number',
                  hint: '10-digit mobile number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                ),
                const AppFieldGap(),
                AppPhotoUploadCard(
                  title: _visitorPhotoPath.isEmpty
                      ? 'Upload Visitor Photo'
                      : 'Visitor Photo Added',
                  subtitle: 'Tap to take or choose a photo',
                  imagePath:
                      _visitorPhotoPath.isEmpty ? null : _visitorPhotoPath,
                  onTap: _pickVisitorPhoto,
                ),
                if (_visitorPhotoPath.isEmpty) ...[
                  const AppFieldGap(size: FormTokens.spacingSm),
                  Text(
                    'Photo is required before submission',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: FormTokens.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
            const AppFieldGap(size: FormTokens.spacingXl),
          ],
        ),
      ),
    );
  }
}

String _zoneLabel(Zones zone) => zone.name ?? zone.toString();
