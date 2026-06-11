import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/camera/presentation/widgets/pic_image_widget.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/visitors/domain/requests/visitor_request.dart';
import 'package:student_id/features/visitors/presentation/providers/visitors_controller.dart';
import 'package:student_id/features/students/presentation/widgets/photo_instructions.dart';
import 'package:student_id/features/visitors/presentation/widgets/visitor_id_card_preview.dart';

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

  bool _isNameValid = true;
  bool _isANValid = true;
  String selectedPhotoType = '';
  String studentPhotoPath = '';
  StudentEntity? studentEntity;
  String visitorPhotoPath = '';
  String releationShip = '';
  Zones? _selectedZone;
  Zones? _selectedInstitute;
  Zones? _selectedClass;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameTextController.dispose();
    _anTextController.dispose();
    _sectionTextController.dispose();
    _visitorNameTextController.dispose();
    _contactNoTextController.dispose();
    super.dispose();
  }

  void _openImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => PicImagePopup(_onImageSelected),
    );
  }

  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const PhotoInstructions(),
    );
    _openImagePicker();
  }

  void _onImageSelected(String filePath) {
    if (filePath.isNotEmpty) {
      if (selectedPhotoType == 'visitor') {
        setState(() {
          visitorPhotoPath = filePath;
        });
      } else {
        setState(() {
          studentPhotoPath = filePath;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final instituteType =
        PrefUtils().getBoolValue(SharedPreferencesString.isSchool)
        ? InstituteType.schools
        : InstituteType.colleges;

    final zonesAsync = ref.watch(
      catalogItemsProvider(
        CatalogQuery(
          listType: ListType.zones,
          lookupId: instituteType == InstituteType.schools ? '1' : '2',
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
          listType: instituteType == InstituteType.schools
              ? ListType.classes
              : ListType.colleges,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Visitor Details')),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: zonesAsync.when(
                                data: (items) => DropdownButtonFormField<Zones>(
                                  items: items.map<DropdownMenuItem<Zones>>((
                                    Zones value,
                                  ) {
                                    return DropdownMenuItem<Zones>(
                                      value: value,
                                      child: Text(
                                        overflow: TextOverflow.clip,
                                        value.toString(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedInstitute = null;
                                      _selectedZone = value;
                                    });
                                  },
                                  hint: const Text('Select Zone'),
                                ),
                                loading: () => DropdownButtonFormField<Zones>(
                                  items: const [],
                                  hint: const Text('Select Zone'),
                                  onChanged: null,
                                ),
                                error: (error, _) =>
                                    DropdownButtonFormField<Zones>(
                                      items: const [],
                                      hint: Text('Error: $error'),
                                      onChanged: null,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: institutesAsync.when(
                                data: (items) => DropdownButtonFormField<Zones>(
                                  key: UniqueKey(),
                                  items: items.map<DropdownMenuItem<Zones>>((
                                    Zones value,
                                  ) {
                                    return DropdownMenuItem<Zones>(
                                      value: value,
                                      child: Text(
                                        overflow: TextOverflow.clip,
                                        value.toString(),
                                      ),
                                    );
                                  }).toList(),
                                  value: _selectedInstitute,
                                  isDense: true,
                                  isExpanded: true,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedInstitute = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please Select ${instituteType == InstituteType.schools ? 'School' : 'Colleges'}';
                                    }
                                    return null;
                                  },
                                  hint: Text(
                                    'Select ${instituteType == InstituteType.schools ? 'School' : 'Colleges'}',
                                  ),
                                ),
                                loading: () => DropdownButtonFormField<Zones>(
                                  items: const [],
                                  hint: Text(
                                    'Select ${instituteType == InstituteType.schools ? 'School' : 'Colleges'}',
                                  ),
                                  onChanged: null,
                                ),
                                error: (error, _) =>
                                    DropdownButtonFormField<Zones>(
                                      items: const [],
                                      hint: Text('Error: $error'),
                                      onChanged: null,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        classesAsync.when(
                          data: (items) => DropdownButtonFormField<Zones>(
                            items: items.map<DropdownMenuItem<Zones>>((
                              Zones value,
                            ) {
                              return DropdownMenuItem<Zones>(
                                value: value,
                                child: Text(
                                  overflow: TextOverflow.clip,
                                  value.toString(),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedClass = value;
                              });
                            },
                            value: _selectedClass,
                            isDense: true,
                            isExpanded: true,
                            validator: (value) {
                              if (value == null) {
                                return 'Please Select ${instituteType == InstituteType.schools ? 'Class' : 'Year'}';
                              }
                              return null;
                            },
                            hint: Text(
                              'Select ${instituteType == InstituteType.schools ? 'Class' : 'Year'}',
                            ),
                          ),
                          loading: () => DropdownButtonFormField<Zones>(
                            items: const [],
                            hint: Text(
                              'Select ${instituteType == InstituteType.schools ? 'Class' : 'Year'}',
                            ),
                            onChanged: null,
                          ),
                          error: (error, _) => DropdownButtonFormField<Zones>(
                            items: const [],
                            hint: Text('Error: $error'),
                            onChanged: null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _anTextController,
                                keyboardType: TextInputType.name,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9a-zA-Z. ]'),
                                  ),
                                ],
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  label: const Text(
                                    'Student Addmission Number',
                                  ),
                                  errorText: _isNameValid
                                      ? null
                                      : 'Please enter Student Admission Id',
                                ),
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'Please enter Student Admission Id';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                final studentRequest = StudentRequest(
                                  instituteId: '${_selectedInstitute?.id}'
                                      .trim(),
                                  classId: '${_selectedClass?.id}'.trim(),
                                  admissionNumber: _anTextController.text
                                      .trim(),
                                );
                                studentEntity = await ref
                                    .read(visitorsControllerProvider.notifier)
                                    .lookupStudent(studentRequest);

                                _nameTextController.text =
                                    studentEntity?.name ?? '';
                                _sectionTextController.text =
                                    studentEntity?.sectionName ?? '';
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'GET',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'Ex : TEST4545',
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameTextController,
                          keyboardType: TextInputType.name,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9a-zA-Z]'),
                            ),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            label: const Text('Student Name'),
                            errorText: _isANValid
                                ? null
                                : 'Please enter Student Name',
                          ),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter Student Name';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _sectionTextController,
                          keyboardType: TextInputType.name,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9a-zA-Z]'),
                            ),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            label: const Text('Section'),
                            errorText: _isANValid
                                ? null
                                : 'Please enter Section',
                          ),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter Section';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Visitor Relation',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          items: ['Father', 'Mother', 'Visitor']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    overflow: TextOverflow.clip,
                                    value.toString(),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              releationShip = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select releationShip';
                            }
                            return null;
                          },
                          hint: const Text('Select Visitor Relation'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _visitorNameTextController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9a-zA-Z]'),
                            ),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            label: const Text('Visitor Name'),
                            errorText: _isANValid ? null : 'Please enter Name',
                          ),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter visitor name';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _contactNoTextController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            label: Text('Contact No.'),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            visitorPhotoPath.isEmpty
                                ? 'Add Visitor Photo'
                                : 'Update Visitor Photo',
                          ),
                          onTap: () {
                            selectedPhotoType = 'visitor';
                            _showDialog();
                          },
                          leading: const Icon(Icons.photo),
                        ),
                        if (visitorPhotoPath.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            color: const Color.fromARGB(255, 211, 211, 211),
                            child: Image.file(File(visitorPhotoPath)),
                          ),
                        ],
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true &&
                      visitorPhotoPath.isNotEmpty &&
                      releationShip.isNotEmpty) {
                    final visitorRequest = VisitorRequest(
                      admissionNumber: _anTextController.text,
                      visitorName: _visitorNameTextController.text,
                      relationship: releationShip,
                      studentName: _nameTextController.text,
                      sectionName: _sectionTextController.text,
                      instituteId: '${_selectedInstitute?.id}',
                      classId: '${_selectedClass?.id}',
                      contactNumber: _contactNoTextController.text,
                      photoPath: visitorPhotoPath,
                    );
                    Dialogs.loader(context);
                    final response = await ref
                        .read(visitorsControllerProvider.notifier)
                        .uploadVisitor(visitorRequest);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    if (response != null) {
                      await showDialog(
                        context: context,
                        builder: (context) => VisitorIdCardPreview(
                          StudentEntity(
                            name: _visitorNameTextController.text,
                            schoolName: _selectedInstitute?.name ?? '',
                            admissionNumber: _anTextController.text,
                            profileUrl: visitorPhotoPath,
                          ),
                        ),
                      );
                      if (context.mounted) {
                        context.go('/hub');
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: Text(
                  'SUBMIT',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
